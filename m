Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98C5D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 06:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313B36B0369; Tue, 20 Jan 2026 01:27:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1896B036A; Tue, 20 Jan 2026 01:27:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7F56B036B; Tue, 20 Jan 2026 01:27:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF7C6B0369
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:27:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F112D2249
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:27:38 +0000 (UTC)
X-FDA: 84351360996.06.E9E5671
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2D031C0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:27:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CH2la0no;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768890456; a=rsa-sha256;
	cv=none;
	b=7j0tk0rwmVU2gXezfWrQCNeikMFe1fF9vQdV2fcLGEpuOWcBfl/HxUio7P4E70Rb5gtkVE
	jK3p3sXtJ4Is7Q+Fr5zfO7rsQBrNBjJu0FM8mNCxt2Ca56cJOOZTeWlSyFEct+UrpUblxv
	T0M6+OvFaIvjJuv8zRDVaEn5hjAP48A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CH2la0no;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768890456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1TQMPSXv5PjTxr6RBKljUmzcShoTJ2wcS+IGRnPiEo=;
	b=zTdTtocs/lyzVrEgufTFZORzIKqKv/slJPv8HZ7zaHAmRdnS0D8fbxTM9BKuEVCLztswpl
	7BkJQfQM4EK+RUYpYiDUiTyf41ZC1ZDap67MS2uKlsladto5+MuPS9CkUO5W1zSCMjODDO
	p3PB/R+mE6ebgnqyy/siX94Uhq1uAe4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768890448; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=D1TQMPSXv5PjTxr6RBKljUmzcShoTJ2wcS+IGRnPiEo=;
 b=CH2la0noBDTfmNxG1mvb65RbwKCp2kcAoyUGrNBcRMGP5unjqoJp3Z4MI8Rh6tLNPXiDJD
 HRfqwtc9IW4GNVkZXGC4pdEANZAbV9jVKburZ8o/Kt9hoO8ZGcJWDRgTes0MdhoVC2DJ34
 MaV0D8+GDs8hgtF6jmanDNt0WTGXUVEkE5ongYYTcFDEjK29t9uT9/XnO221pVD88hOfMC
 UrDShaPzVyv5paKgf7vEdjIEl6e8E8d7oASD057HsxV914OSpZiBzcgLkDJTl6FODSX2+h
 FIdRAa2Xhi4TLf824nAr1OGdJyCXCZw/iPyQfYW53q/RU91eA608F3Lnjmh1jw==
Date: Tue, 20 Jan 2026 14:27:06 +0800
References: <87wm1ih5kb.fsf@oracle.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <87wm1ih5kb.fsf@oracle.com>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <dan.j.williams@intel.com>, 
	<dave@stgolabs.net>, <ankur.a.arora@oracle.com>, <fvdl@google.com>, 
	<gourry@gourry.net>, <joao.m.martins@oracle.com>, 
	<jonathan.cameron@huawei.com>, <linux-cxl@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>, 
	<wangzhou1@hisilicon.com>, <zhanjie9@hisilicon.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2696f204e+c0d068+kvack.org+lizhe.67@bytedance.com>
Message-Id: <20260120062706.91078-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2D031C0006
X-Stat-Signature: ca8u1iyzgp4ngmjkktd3hamiguu1ssm9
X-Rspam-User: 
X-HE-Tag: 1768890455-62913
X-HE-Meta: U2FsdGVkX1+5RiIAHCUHKJF57cJTia25IjFqQcjYOu25Gqoh50F/7o4Lj6GMsxLnaSM2mSK96CCvV09JW6Hu38f1Hj0A8/sI/13XVfpi9qZpmCZ38mp1yFojGXK5L44TNTplZjPCMqfATy95oGXPw74mxiJA+/Ev8ulzoqSk+tiJS0QOQRSxhPm7jYoSIQJZnrZXL6tQ1vL3hPub55ZxPQl2MOinAPx1mm1Fj0KZxyHK/C1qM3ylQ+BjuAN+TNyWXB67w+W5j+lvUr57Mz8kExxf45vx3DGtM7ZxtRZLJ9EM7qdll9IpsCL4TLNgErDQTFmKVaDZAL40hqLCGiuic9uKoXGA0r/43J+iENm18byP2dKCAUrHHUFAEwmQGku422Mys+w7AfwLgWHJ0WS2bTvP//aMPuYUUUkJutA+wrk4MD3acte+81mVroTEIg+GV8Flitd/Cxpb4eRQ8n2IXZOMoPSSX7szATy4dszl/C9Eiixchsz+R/UdWXYiC+VsWAdQGeXsabwa4RgsGwjXaFpLmGAxxsM+xQ7B1GVnSVSDVizCoenKCodyB7sfbAFw/TkSL3tIh5ZQdXDhPz61EbvghP9GrSff9jQ4QDhcfSsbZ+YIGFi2GQ3BFFcPTIb5tvVgnTpOOF3Zc3s97qoIzPk1IFMaKnAQjtqfVo0dr27e/HBlssU+3eUaLZO/zO3G5DF8oEkVkCbh+H+D0zLrweunxkk2Pb9WyO2ZRs+T3RJPYfodJdWJy+KWd4VKuhkJk8GsTv3xIeVF6mHAX8X0oyNRM3Y3D7CTZBq62q95MPUBUmUbTGsn1SV5QdB+43an0JAm/oHpQxBJOmoFORvC/9x2/Grfu/royQXmtMgjXpPjEnIpt0asB08SOgFkaA/5kdWlsdB7G9sPSbokg//CM/WLx+Uc321lAmeHX48HiNLBpCLhXyxsjQwiZTNmc2EOpvragZbDzoi7zTQ6kd5
 XL2unDIR
 QOyo4YO3H7D+LYr27rkxiG355wItLQq6VCmK6xTmkjVlMd3FRpWW6VWNwYlTJkJuLP/gT8Aams4k6+O6H7y9Aq7iiJeGns2km5acMTBcLdk4dkO9lU88qSG0mYYFDVh1C+ck5wpDn8AjiAedO1uibU4sLxQXqf6H12NwWL7YLAcyxM+bYy31iak9lW29manK2cpotX19+EdkYQGFclwBgV/J8v/0k4+ClnVYPCg3DDNicjgAwKvgwA7I9wIwpCqehKiC3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In light of the preceding discussion, we appear to have reached the
following understanding:

(1) At present we prefer to mitigate slow application startup (e.g.,
VM creation) by zeroing huge pages at the moment they are freed
(init_on_free). The principal benefit is that user space gains the
performance improvement without deploying any additional user space
daemon.

(2) Deferring the zeroing from allocation to release may occasionally
cause the thread that frees the page to differ from the one that
originally allocates it, so the clearing cost is not charged to the
allocating thread. Because this situation is rare and the existing
init_on_free mechanism in the kernel already exhibits the same
behavior, we deem the consequence acceptable.

(3) The function __unmap_hugepage_range() employs the MMU-gather
mechanism, which refrains from dropping the page reference while
holding the PTL (spinlock). This allows huge-page zeroing to be
performed in a non-atomic context.

(4) Given that, in the vast majority of cases, the same thread that
allocates a huge page also frees it, and the exceptions highlighted
by David are genuinely rare[1]. We can achieve faster application
startup by implementing an init_on_free-style mechanism.

(5) Going forward we can further optimize the zeroing process by
leveraging a DMA engine.

If the foregoing is accurate, I propose we add a new hugetlbfs mount
option to achieve the init-on-free behavior.

Thanks,
Zhe

[1]: https://lore.kernel.org/all/83798495-915b-4a5d-9638-f5b3de913b71@kernel.org/#t

