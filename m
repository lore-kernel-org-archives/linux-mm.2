Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B5CECCD1A1
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 14:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA138E0015; Thu, 16 Oct 2025 10:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A518E0002; Thu, 16 Oct 2025 10:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589968E0015; Thu, 16 Oct 2025 10:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4457A8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:38:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 056F3119652
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:38:18 +0000 (UTC)
X-FDA: 84004232676.25.761D908
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4A0F140002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:38:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=sP7uyKiy;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf23.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760625496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3S+3Ynz1TOt/M42tcxbRtEI5ZJy9u2qfBu4zK5zMEA=;
	b=nO3tSNqYdtdZW4826QLRU/u12E6WusBody7rdJmgyhsIQ4NgrL10c2b+fiZEe2gwzy5+Ph
	XL2CT+Zbv3BB9thd26KCZq3MaDGHIHxDuEkWa3dfxKvUlabr31pZCY92aetyMSd3HmMRjN
	XNnIHC4vNSDeASmogEg3kZLb0QJpZbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760625496; a=rsa-sha256;
	cv=none;
	b=cRXFbl4dE8VBUQMAapM9QJSye1y8Q93XLPNAEJqxpT1wFU2nULoq/uD0v2PhmJXIY96Psu
	GAxklxyZKzdpRy5bYbeqYUYphv0RT0kUMKseyV4XGLNODnFWC7gNS4t+N8cn+tv4tsaxXz
	/ZIRdUHP2okM1KVR1qfuJYZc6aH482s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=sP7uyKiy;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf23.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760625481; x=1761230281; i=markus.elfring@web.de;
	bh=H3S+3Ynz1TOt/M42tcxbRtEI5ZJy9u2qfBu4zK5zMEA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sP7uyKiyjCTlf9L2EGy5w6hH+h8dYkL/VKmTSzU2MUcAzWQyrfZgI310H+sCD75D
	 EcRPAEBfuF1ColE/w1p3hjrQddPFjP1SrZ+O59SH6OI6bunkrCkgO0xCPRcOPg00C
	 WLigMrdob5xg8lcqHA97nExneCTSC92SESRJO12k76M+QVKvACwsiA+FEoi3Vk4sd
	 hxU1Qmg13gbLXU0k3fscj+tRkzlPgiRAm9IVtRbV25OFa0U6K3fXoUGqyLWaZ81/E
	 1h+pmFoeQYkhYV8pXL/zYrmg74ZRvDF5F8/OEsBm8ZRnt7c2xrKbS6Ddy/4me+QfB
	 iOkkrYIvKZ3FhzFelA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.241]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MP3CC-1uqnu12Y3g-00TXEe; Thu, 16
 Oct 2025 16:38:01 +0200
Message-ID: <add77995-2e39-4f8c-b827-766fa8631ae2@web.de>
Date: Thu, 16 Oct 2025 16:37:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Longlong Xia <xialonglong@kylinos.cn>, linux-mm@kvack.org,
 David Hildenbrand <david@redhat.com>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Longlong Xia <xialonglong2025@163.com>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 xu xin <xu.xin16@zte.com.cn>
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251016101813.484565-2-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gwt9OktpJPWtxjzPqwm43XtHTgOiFICpuSNp/HZnEhNZtvITuJj
 7QJ5wVwYlOHnNkiLQwGMD6ykaYsSM+5bgxtWdeqoSk5KRFJE1TxNmiPIlenxv+vByNAB4kr
 ZsJZjIKsrKe2mBHok9zcJqsMwrrrP/vhIS9QZGJ7dFf8ZsAvVH2lgwZGaWYD9P47NQD1Bmj
 9xwdCHItqQo3xwDtt9jaQ==
UI-OutboundReport: notjunk:1;M01:P0:6Wtu4e621cY=;9RiPC9wTL8BiiTYjiX204RHXYN9
 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
 Veopc5c2HBr/7YNxIq/RqJgLmI=
X-Rspamd-Server: rspam01
X-Stat-Signature: hc4io65fgkdhraix8bw6x733juu7ejq6
X-Rspam-User: 
X-Rspamd-Queue-Id: D4A0F140002
X-HE-Tag: 1760625495-247916
X-HE-Meta: U2FsdGVkX18iYm3oXCojQ87YLHish8QIIK8Z9QlhXHM9gR49zJ0lcLx0aLg/K2f46mZ6DK6iRsEQve8PO+L+VmvG6laoHX8vzmHx73cU7hjFUoKxHmGNwCt63pN2aYBFq8rxdG15twZ7uLq/D6cL4bDOfPcVYS+jEIzEcx/yefmnS77BeourEdnL6ePzpa1WgFXHCnsupdsk7bXciHSwOJ8BDNhEb1LgQCzUZCzYA0tOZx2mmeb9E8yomVqtzCHOP2dPdob3PsPJ8Upzh5WPfrlXwwgK0vqkkMRUgtIOr2Uu03ScxsbrgzJT/EzdsMKUj/G4wKi4aSIxSLJ93j7UfzJWm1rnVCZMBk/OnjmoEvnul+SHpbuLVghuoV5z2c0tl6IPcRtPRL5+UB+qmXLhA0Lo2My40yT9wqlWgDhbVPgZw1RXYekBsNoOJ035v9c0Xou2ms+YsSDArML7Cz2w/u30UqYxJx1XE/bWRCaIVX6O7rc1C3HFcRe060c4aZ0KpW5z/3SgmUBHPoVKPLIFIBVLjbi17TJCvEz1ufZ7QerGnSt0K1NQ2atuvIM6WcQL/iKfyCmZ5S/BFPBrmGOiP7OEj9MSLZpp3SET4P8MU3N79BNF1mAOmXekSjtaFeb9f/MDzBAOcdQyPVj5TDyMknk54WfYna9O1KtWYJOO6nFataAYGw0o/z/3MwqY2DPaLHRyQmFjHMHopHRXN+TnHxAklxH2LYfgjRoipiaxbPXb1hHX8o07iV2ybt8lc94jiN7xclq/cvfQrWfNmowZeOz5h6Vah5nwWq/ewnXC/jzmgsRT4kbyOsEHvXp+MLiK0Y3C00r6PA1YN6Oi8/glOWELNQcv6K5x4u+uyXQRr7mu+OalH01/jyzvzRE6ENiXU7rUlhNhckhnxjSf7viN1RJ/oyMJYUrPg39M989HxAtMvl4SEZoZD8qKrBIiB1yrjcQqaitZf4mSIBmnO2j
 3zUdeLkq
 6FhYBlbed8okxCDrYCUQxamHJGU9rgBqZdN2i8yVtMAk9OQm8MtAmLJfcbIohMNDLMTD2q3kyKLlObr0pgbeD137MXYMDPwrEq7L6d1l+8N5+FDLanQLjIbRbN7QreQPsiKIdZnkcw5lhH+XztzVggVF+GRqCatkqHyDUtT7SEgrzz/3ugh5kkrx8OEBRRk/QcNgVFmXk/GsVyyvbWOj6E77pQm4Lv3XMJInx0oHOealYM1SksXjIW0RhGADbTqLugHNO8z7gjlJzyNiPkuf8qDBNKw84fOn775k6z4fcXYEYMLMNN6x2+dCSD8OlanZtXgR3ADLaaHWQaHnD27VMcBWU/iyFDx2fzv2nVVJGWS7UVMvu/bH/552Zsaui4xOprj6HigIt5wV7rdri1O9OnBpdKg6okEgfsQm2YyQ8bVn3fnVihmSUN0jCueVAJ/K+iKAQfwaZvpxfSpQ4AfdKKc9YtyS0emhtT3EupzYLdkPK6JGVThpjL+syCrPldJeVWl/UxiNmPwdRmnAx89AMMIQXZnYhA/1jLDXY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6> This patch introduces =E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17#n94


=E2=80=A6> +++ b/mm/ksm.c
=E2=80=A6
> +static int replace_failing_page(struct vm_area_struct *vma, struct page=
 *page,
> +		struct page *kpage, unsigned long addr)
> +{
=E2=80=A6> +	int err =3D -EFAULT;
=E2=80=A6> +	pmd =3D mm_find_pmd(mm, addr);
> +	if (!pmd)
> +		goto out;

Please return directly here.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.17#n532


=E2=80=A6> +out_mn:
> +	mmu_notifier_invalidate_range_end(&range);
> +out:
> +	return err;
> +}
> +
> +static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
> +		struct folio *failing_folio,
> +		struct folio *target_folio,
> +		struct ksm_stable_node *target_dup)
> +{
=E2=80=A6> +	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_nod=
e->hlist, hlist) {
> +		struct mm_struct *mm =3D rmap_item->mm;
> +		unsigned long addr =3D rmap_item->address & PAGE_MASK;
> +		struct vm_area_struct *vma;
> +
> +		if (!mmap_read_trylock(mm))
> +			continue;
> +
> +		if (ksm_test_exit(mm)) {
> +			mmap_read_unlock(mm);
> +			continue;
> +		}

I suggest to avoid duplicate source code here by using another label.
Will such an implementation details become relevant for the application of=
 scope-based resource management?
https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/mmap_lock.h#=
L483-L484


=E2=80=A6> +		folio_unlock(target_folio);
+unlock:> +		mmap_read_unlock(mm);
> +	}
> +
> +}
> +
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_no=
de)
> +{
=E2=80=A6> +	if (new_page && new_stable_node) {
> +		migrate_to_target_dup(failing_node, failing_folio,
> +				page_folio(new_page), new_stable_node);
> +	} else {
> +		migrate_to_target_dup(failing_node, failing_folio,
> +				healthy_folio, healthy_dupdup);
> +	}
=E2=80=A6

How do you think about to omit curly brackets?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.17#n197

Regards,
Markus

