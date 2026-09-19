Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A67C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 02:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358B36B00A6; Fri, 18 Sep 2026 22:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329656B00A7; Fri, 18 Sep 2026 22:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265B36B00A9; Fri, 18 Sep 2026 22:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFCC06B00A6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:44:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9394C140174
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:44:47 +0000 (UTC)
X-FDA: 85228969014.10.D7930ED
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80634100007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:44:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WPxn8+J6;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789785885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf8aRgT+D3tVDYVzq3plZ7P7dwfjZ/5GkDFwuIucz+g=;
	b=nt2drkG3yXpQ23oQt1JsKVUhfRQz8N/foK2a8VsnMsBoiCrsBV7DRVh2V1e8GJnD0QfWbx
	Y5mlJkhegwqYUkpLrfB6ozAKtZ32ZhTsB+460u8IhjNfr9vMgafXOGM5DMpRd8zH+O2tzx
	uwD2US/LVX8tJLFWxZrjyBJ2ybX0jPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789785885;
	b=3/3IIRLgIZ9BA3ZcskZHC1FowUNb/lRdQ3077lSj8eEeBS882nZnLZ5x1h93UnxkV7g/3o
	VpOpbcaPGLSMlEXb7QBAfLT/phQIPoajaeiK3ZWfJmWKzf9moW/Am+zjrBDfK78dy1Hexz
	jvZp6drc9m2aix/quxuqGbEBWYN20f0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WPxn8+J6;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gZMNTW6sgM4aJk8DzB4CH3HxK4yTRxgEOhMVRmrJvLU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789785884; v=1; x=1790390684;
 b=WPxn8+J6+DuIp1hrAvHCmAY3FbO9Dvf3irtMYRvQPr+d6+TMmIVFF0rVnSWRoywPCJ1VevEz
 6VfPS0c0fxvnld7650Yy6B1FY+NfxjfXFmdYnrYxuwtbRCBCNZ1ndqn8vs3Yb3OdriQROU3e9xF
 0lp2iYaEDTXmHOGA775BzlXQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 0b1a70147224a31d;
	Sat, 19 Sep 2026 02:44:44 +0000
X-Mizu-Trace-ID: 0b1a70147224a31d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>
Date: Sat, 19 Sep 2026 10:44:26 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <3A433465-3F87-4268-9B1C-73DEDBEB6A90@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-2-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: 4dxm95qriaedaa7ragy8ho4qqf6t43ex
X-Rspam-User: 
X-Rspamd-Queue-Id: 80634100007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789785885-777836
X-HE-Meta: U2FsdGVkX19oDyBOrjEz1Ud35/YQpKE5dfSNJTbCzOcL8HhDzjCevZ9JipbMHx6zFGDD9s0669gS7b81NmDxA1ktBtYrSqh4BcuwY9i0oTzrdl5fFwGnhQeKgdH2ImEXbXT0idPk//kxa/c9TbYiOfDqz2Ksclkj6VygDiMCugSLy0qioosIWkbre0BtRhxQ+8C9f0n9mBWRTkSBvgvL8FiZmCMKR5aP04buDBxnqbiMCA3nPImrMxiZ8Lvi7rfaVGEIVh8NTuO0mFPKH/flfRW8WIGKywfPyOo2eHtDqvufrcxQ6pfdLP8/Z1FSl9jOOqrxhZ+QXhvwrs7A9RuZXqzzCkrTw52RlIAXcS8gw5BtJFEq5GnkoA095V5KCx9WdWSkmYlRxZvspEEA3eTzaWMR1aKodg0SNQ/gsn/IXSA4uhDmeawG1+mNrpNr3obJx1LeBH+NpmRLW43HQpXEmTpyrqOF5jOxnckKnfLfQlErZUB94UVmewPGFwy05b4r8JXpDxLGgfnzSYUyyxDKU1E5YbeZ/oCevlCQl3/UYfexuggHsNvJ3NOosK1DMfuDPs0Qv+yGqPx5ZEPFrqDH3/3JCoYutisi/j6s9/xjGB1wKwsJpX5agQTrz/g0a0W0ds381m+JWLwmqraI6M3Qv/G5tlvHylRFkG0gdPxNbjkS0CAu1TeBINissac09kAlRtknpkPEIDzg2+HY5N3oYtm5ywEZBS9Bi34bZwK27m0DeVijzACa7lNGygWzYWtNja3cG3QKA9ktrzlTZ4EDJpHkgixtUJgIBkyWdradBanqWTXWDaSRFh+zUWzyX4kxGazDaccVdKe2IOCAkIH1BKoEJ+J4rsTQAnIZYtmjr+68+woVAwCLE4sJJeJENg8qIyn1o7xyjf4PDxLkDesy12mJUt9QYh0WO0w3sONE5YOOuKfeWm9MEXY3+v5ouA3La/1Qj+quLxe8DdhBgkp
 4qdgaq82
 dDWCftUENEF0Oi/HFrkXkvaa6gIRXHVb2e2domAulqzCpDxWGioWB3w1T/aeVqPoiGp/Uf4mOcCM5Fp8pj63v30Ok2kzA7g0fD8YcKVYSBcIwaYSOoA7eb53RF/gjKVuILPO6NRDlqTn8b8WywbBfnL8cG0hYl5p/g8WB0+mCnRwYsDDCHZlW/6awqXA67stBwZ2NOh88nFbgbluOHAW2RY92NUonlokH81hWKHO/RC0IWKnKZnrEvamNB3PjQ8p7u6CuqNst6er5jTe01kR74WHeZuqLxkyVWV4SSiXfoLpog3PqummO55gfw7OckNEnthNvgDyuk65uaxh8gl/bNMvBwKVjEL3x7YQ6AWOJPU99RNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 19, 2026, at 00:55, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



