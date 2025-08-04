Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4C9C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 02:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9FB6B007B; Sun,  3 Aug 2025 22:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AE16B0088; Sun,  3 Aug 2025 22:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A06F6B0089; Sun,  3 Aug 2025 22:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB6D6B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 22:48:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06693115742
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:48:06 +0000 (UTC)
X-FDA: 83737540572.19.0E524E5
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id C2BB3140003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:48:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OJ1SV3F+;
	spf=pass (imf09.hostedemail.com: domain of "prvs=304d5a7b7=apanyaki@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=304d5a7b7=apanyaki@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754275684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKicLz6qk2kkguAEni1vOqzECVIHBfHvbbyhd4kVsDM=;
	b=J2ke40Y4Nt0UI48V344E0ACG7EpzLsGIGzI6VwQvEB30NQyup3siRwAZoFhdssbeY9r/9t
	ft/DetkBffHOu5cchZJoOw0SDDL1WpzCTsk2RkOhVlcF+FfdmXCJGMkYKY18V3U/VdLVUk
	+rzjSgRStlurDtjzHWAJEcqc8jT8YPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754275684; a=rsa-sha256;
	cv=none;
	b=5peG7SVaMUQFY0kqwhWQT9ZvbEwjYlO8FAJt9VQLaiyGbvNlKhfrATnd+nANzDB4D5Rz5F
	0cVHDiti+Vg2TiKozkAtNtDKBZ1pMbSmM2nAPXtWrTbr+O/La5AgyZ+3tKRDcbDFxjGceJ
	0zM3ZLp7M7kUNnOxT5qGmBSNs+qFAzE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OJ1SV3F+;
	spf=pass (imf09.hostedemail.com: domain of "prvs=304d5a7b7=apanyaki@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=304d5a7b7=apanyaki@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1754275683; x=1785811683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RKicLz6qk2kkguAEni1vOqzECVIHBfHvbbyhd4kVsDM=;
  b=OJ1SV3F+dMH7aOHcep0SDiyRGzONOi4VuOc5TjCA6uBC4DCsvBTVZ9kK
   zt863fiSDKdl7FaRcp7wGoMer9QrhIzaqOzGNheS+ug/o5lxuIeqXc1Yx
   uQyZQ3guORQIWZsFn2F5g6w0wtTx/pmBXv+ble6kQH8Sg9OqlokfIuBNn
   SA9QloCx2a3X/eg965mVoGbFnVqoTovldrKSHkquzJSTnvbBQT/ZOw/3K
   g5zM8pF3BAcnDD8QL+Sk+B9Os9vUUJj7Bkrq9iKNiz3CBBLqGg3CMNaYv
   wEfPv3fgnbP/ar4Z5u3N0MMBvoZrCEhCVgMPoivnSYgAaF5BSmAv64Qaa
   A==;
X-CSE-ConnectionGUID: cCd3RQGgQoqlNkLrBO2LSg==
X-CSE-MsgGUID: VlhjKe74QCGXeEHunRLy/A==
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="414218"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-west-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 02:47:53 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:10198]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.198:2525] with esmtp (Farcaster)
 id df118047-9890-4fac-bbc9-48f9ecc15387; Mon, 4 Aug 2025 02:47:53 +0000 (UTC)
X-Farcaster-Flow-ID: df118047-9890-4fac-bbc9-48f9ecc15387
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 02:47:52 +0000
Received: from 3c06303d853a (10.187.171.18) by EX19D026EUB004.ant.amazon.com
 (10.252.61.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 02:47:49 +0000
Date: Sun, 3 Aug 2025 19:47:41 -0700
From: Andrew Paniakin <apanyaki@amazon.com>
To: SeongJae Park <sj@kernel.org>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Jann Horn
	<jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Michal
 Hocko" <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Pedro Falcato
	<pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <damon@lists.linux.dev>, <kernel-team@meta.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<amazon-linux-kernel@amazon.com>
Subject: Re: [RFC v2 0/7] mm/damon: extend for page faults reporting based
 access monitoring
Message-ID: <aJAfTUh-49pYuhbg@3c06303d853a>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
X-Originating-IP: [10.187.171.18]
X-ClientProxiedBy: EX19D039UWA003.ant.amazon.com (10.13.139.49) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)
X-Rspamd-Queue-Id: C2BB3140003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: wwexdfiyuj4738xr5asuqkh7d8c8d1nb
X-HE-Tag: 1754275683-221862
X-HE-Meta: U2FsdGVkX1/tLMgxq0kJeToGiaNh/CXnGf/1J5wM1wJbl/iWntTX8pAs8KZellC6V037OetdHrCa4MMubVCoAOYrj+geXneBe8SpQoKvqoU8PGejqskMF6I/s438GDd+K5i8zktqJn96LgyMGiao410Zz5RzWvRFiz5W8s5XpkWpYGNspS6/M6iD9emXC6vP6VkpgOe0TzPcINTw0jbIzxwN/434HF3Nbxd1LJ071bxFjI49nJv1076LGsJddTVPiQtiO8Nt7tBM3Ou0V42tjYhRCzF86cGnymMujpGFfDmWzX/uWFKueOiOqMl49xLKqA0aOYS5W46K2yJB5VSHhoOR4DUPOdw97qwVklSUPxu6fm4idw4j0N1nJRdiG21IajjYqaKn5Nbeh7QpgfS4h+Ofk7dM2Xt0DI2eYF9+rHejUriOUpwoTo19OhEPvO4bAWI0p6U1GHUM3un2ecdUF/PsI5ktdervfsNc8JDbJA+kh122KcQxK0nzsamUAo0c9E2BP1BbOWpYOM29HVgww9zwz5hwXr3X6NzoVuMotAFf/5zBYdfuN0VpJGbupHaEtLWpiGSYH/OOIyJKErKntLmFBPI4OKNsTJEGZxP6qhZE7kJyzosCq/CuxOCBPe0Up+kWzRQOKLddPuu0Toa3sTR/6IcGJyN1VRY1tGrC1S6g3lmVdV2V37XaV1oOgNDTtQchTdL8ETt056ec065Nm/EiTrOo+E9olHWGZHbZqDlEQdQMPF4snn6Mdm04g/egDezJ+/zV3fWQCoWKTfaihy7EWMMy/aRu7yLu01xAra5KWUm7W0FfOQtT6seatJaBkZYxRIon28JuTkWtMqnaFJ2K/DQxHC3ErBgvIPy8254pH7ZH7Wwo7zeEhU1k+JS2zl9WoxM3R0Qwo7RZw4RvW632jLpqDD8x5RdnEhHbD7D+XCzPX+oluQYe1EuVmrX+aAFWOU+Grnc3zCoPbDk
 CC5ILFqb
 l/Buxfx8Aor5+HNH2DYavw3VsJ0DgYBENkmu3cU8SnYt0eLueNOLe1FzAWIy94CsQ0/IoOdZHRr8MFXFcMXN+Qr/tVZpQ8nKPEtkXi2uniq6j0ZMIVqYaG1ElCBdHkxAO4nPhxbjEfIC4v851Qh2lsfSbUKWqPkMU7m6ilFoXt3PlRkZY6eIZtwq5zhjav49y9rBm1Po8w3A8zjBbIex4XcJpJdvnAEAqSFyk7rmVBLOyLUF+MoIyzBalhG1rYzqtvtcGETqot2HJWYJdqLU3Tp55kvug5EGmX96E6JQkc+kQICxw8kyaBwAlYte6QGxQjW+7R+gjbwYdnLXn4XHC+xt9ScWQ662jlXKBzoSVGLAEOEuXv7TQGpVM8Cdlwu3OpsbHjjs9S9H1LnRQN9ZOtP6FGq3oikqCuWdcpqe1xmsXHgKhFl8XBOp9kYA5yIwb27cEUxbPlHBZj3icef/jYn72HpWgvImNIOVrJ+/R+ProN6oyq2nqI6lgBVRj4NYSZUrsCSMuOOPQvpGN/SKMotTducBBJdkqxz5kACD3Ynz+2mGYhmgS5KD6izCC1HbwksWghI9kVwbQsXXY3BX0uD2oNX2PaG0Yl5yAC1y4EmH9k29cTlVkAAZ08WxMaxaFjcQnYWNw92p//9bt2DlAoVETF08G0FfTfYZrnexPSzHlB5v8NHz2JdIbPbli/1GGHZbsAmc1UHCUoqCz4PKNnYswJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/07/2025, SeongJae Park wrote:
> TL; DR: Extend DAMON interface between core and operation sets for
> operation set driven report-based monitoring such as per-CPU and
> write-only access monitoring.  Further introduce an example physical
> address space monitoring operation set that uses page faults as the
> source of the information.

Thank you very much for starting this update. RFC mentions write-only
monitoring, this feature particularly would be really helpful in some of
our use cases such as lightweight live migration target selection, so we
are looking forward to collaborate in development and testing activity!

