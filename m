Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A564C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 21:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662366B0088; Thu,  3 Sep 2026 17:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613526B008A; Thu,  3 Sep 2026 17:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529D36B008C; Thu,  3 Sep 2026 17:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3EB6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:28:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E275C06AD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:28:51 +0000 (UTC)
X-FDA: 85173740862.10.9EAD1B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDF0FA0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:28:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6LLObSL;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788470929;
	b=M+9revCC20vtAh/9SczjMNDfkoxPZ5vMm2dc0j5rBlIpX/YBTOLVGf6uye93W/CqEE07qp
	2ecDkDM7RL1rf5uGxtDe7Bio945xL5iQkGOfFw5SrYnsW1K1QgeQUge18Ankx4wXgCew3P
	8YJQyw63RUYzIfSZ/CVcPAkJJIfKenU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788470929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0UGZFBcM14tGAANtsBQoJQ41jp8M2g/X5OqTmiEaO4=;
	b=yxkkiil92Xc11nVCHw6z1az120QiHbONU3xQ7TCEfjWe2IIvdirlp+W4CObWrcdWxgXvrA
	VaAe0asiGWe5aoydDK0yEs/mlJRi8x8GAwVoCOKdp7z2whcu8rp0lAwwiCZnAJFLlAzPVl
	6DxbNq2+ZIveogqMvc/WttrsadI0xTs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6LLObSL;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7942F60A60
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332901F00ADB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788470928;
	bh=k0UGZFBcM14tGAANtsBQoJQ41jp8M2g/X5OqTmiEaO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i6LLObSLtGpatkgwi6KPh3eawDHXxEPmL9XWmOukud9xDMYe73W6TDF+yI+H6LDAV
	 HLKP3nZAkecCFDthJecFI4tVVADwf1Z6bEb9xHCOd1+VDsn+nPXBsut9flDwiOuEZt
	 5sS5Z9P3yoZ5erFjno9cpguThjpLJdTY8e2FCIzHE+IGurpKiaxiFaubgl8SSOMj03
	 Vdpj3IlfsDh0F5fNZJPMqNE6uIHA+ywXW55sWzy8pATHcrOn8Fu0O0SzjwrvoA/N+6
	 Rgs1DWr21E0kV33xsjs1BdaJx61raLLh+xSJ0gIux4qDhhYv4y2e9T9F8XcOiAfHlV
	 I2gahjG86Zxbg==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-90cc372d6b2so4860526d6.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 14:28:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxT6wExSZK0SLMUfV8Las4NFpSdSXLcohbMJF6bfWFUDf5mWUJEgNehMYGTxITUjpjSKjJNjwHNdA==@kvack.org
X-Gm-Message-State: AFuF++lwZ7nPJ90DNd2TOQPY7mmTZDNAH/68Zm7hwF1okN26lN/wgW8h
	lTPuMQjezUAwZ6ulGZVGW87i9SVaXAsBqz9cgigwCExk6BlH0HOq9pmm+tuzRKO/9jDcUs3sWtW
	pZ29qV7puRtv2plrGiMfW0zRuhc5/RAY=
X-Received: by 2002:a05:620a:21c9:b0:939:597:e7af with SMTP id
 af79cd13be357-939804784a0mr126943385a.35.1788470927443; Thu, 03 Sep 2026
 14:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com> <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
In-Reply-To: <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Fri, 4 Sep 2026 05:28:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
X-Gm-Features: AcwNN1UfF8fjF6Gm62yh0ikVnF99aXRfOugf7CCehE6ggJ06AxtYcFJ6rS-ls8g
Message-ID: <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Tal Zussman <tz2294@columbia.edu>
Cc: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org, 
	qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BDF0FA0005
X-Stat-Signature: ttrpuxezyunogtz46ch7dj7pffg5zw7a
X-HE-Tag: 1788470929-492133
X-HE-Meta: U2FsdGVkX1+JTEzZ1Ms132DwjA1NFBpZCovSi/dXS3t1/wQThrn1yMro2pgsdyIOw6Q/Rc3mz2zEB9IdpTzSrxurzlEagfv1d4sF3tW61B7I2RnxWBOyYUWCtatBEoJJCYOsNkb//WJlyAU7/68cN23pvonSVD/rLpv+9G7B4GwPGZYTZNPLJDypgc5UpHpHsykQc9DDeUwwz+FFkr2HDAYdCT3DGbcinCyMn2Qv0ooKanNFRkBj+2iHC42rlebKvuQ/0jGHzL8iLp1tqc5J0QiRSMG1CipWn7hTJYRwfTOGVMbyBM5iBhKkbakQzqGC6ggWzl20SnGPKgEjrYBqpI5j7zj+zxdGqwWsvtPT+dzSM0Sp5U8lRQW7HE9TcEFE/d/4nbl4/Yk0xSGPBuDYU7MgSkP78rCoTvy/BQtimgvJvzXhVIVtiMEWzsmn8WlrD7OrD8EvloesSvkIKPLM756gP3FX1ii5sSCsDMrztJslVq29BacUNl8Q/CWzryfGFfVL0pQeyLofr2i3y5+Av4P0GBTR1ngDBCjxlZkapyi+Aj/TwBZO0cDtqL2J3V8LYE4C4YNodt98UHZkZ2AEVvtcut4s9caUsVcpeNUM14bhpZcTnt7Cbjbbjs4JvH+TZoC4wv+Ew14O5sk9ArX1gq6PgGFxmdt8+NqGvujlPewyLKFoyDzX16EAjbS5Xj1EV1dptePLSsqeEcbNJsiTRyTbPw3zUz64DG5/ayPjJSp9tLGyPWiFbFdsDZL32eHDDtCGCYHYN8OtXqSDbOYbA7tPSBisk1Ps75z8KRL4wC6YHBg4993rXUOdjote2tF3S9P/S7mLUIhkEGbBAQW8YUKwjsgbwNLDiFRp9cQhtApnVanCT/GMo2imr4qMR3fRuwjZPybv8EqA50Mw5izHXXP7NSNDquIywIpEham9rz7BfPGmCHDWiJP6WfaVR/3um9WNz39d0ZCNZwCU9UH
 WQeewtok
 1CiIiH/SEF0gKlVf6AjQpPFX1zMq+12PnpYdZvw/d5jsW3jmfmLpG8sVXFgAABiTgvsX0Yk01bgTWTibHhsv+NWkWI8z3tSKXsJEVpz+0agg2Gb1QrnLJMZS943XP25ROFsVoqH8FANhnfzg1CyQA8S5dFMMNgkKkQl4SP8Wwdi/Zn2bqcDeeT0cegIIFoopE9G7v8ssWgxb5KgiPkOV0RibOEov87zJUWhbsQVJZDLTEtZ70BEWYeiiMpMrdKcgXTITGN04MRnkX2wpwnlg1bZtjhhgRyneVVwvrb9VuucRa027UdL1VGc+8Y4rn7g7e+A8vx/9iNIIreCtjMsmrsrJwJ4kLsM3c0z9QjoefN4mR1CAdWdibZb5lzprQ7AieGf6J5pDRed+RiTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 7:59=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> > From: Wenjie Qi <qiwenjie@=E2=80=8Axiaomi.=E2=80=8Acom> Fault-around ca=
n map ready dropbehind
> > folios without going through the normal page-cache lookup that clears
> > dropbehind. A mapping represents a competing cached user, but writeback
> > completion can currently
> > ZjQcmQRYFpfptBannerStart
> > This Message Is From an External Sender
> > This message came from outside your organization.
> > ZjQcmQRYFpfptBannerEnd
> >
> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> >
> > Fault-around can map ready dropbehind folios without going through the
> > normal page-cache lookup that clears dropbehind. A mapping represents a
> > competing cached user, but writeback completion can currently unmap tha=
t
> > folio. A later mmap access must then fault it back in.
> >
> > Retain mapped folios instead. For a mapped folio,
> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this path w=
hen
> > folio_end_dropbehind() runs in non-preemptible task context.
> >
> > Unmapped dropbehind folios continue through the existing invalidation p=
ath.
> >
> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when wr=
iteback completes")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> > ---
> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
> > kernel retained the mapped folio and continued to evict the unmapped
> > dontcache folio. I did not reproduce the sleeping-in-atomic warning and
> > am not aware of an existing report.
> >
>
> I was able to trigger the sleeping-while-atomic BUG on current mainline w=
ith
> some help from Claude. The reproducer itself is straightforward enough, b=
ut the
> configuration was a little finicky. The atomic context comes from using
> threadirqs so that virtblk_done() completes requests from the irq thread =
under
> local_bh_disable() and the vq spinlock with irqs off, so in_task() is tru=
e but
> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion=
 stays
> in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_i=
o runs
> inline instead of on a workqueue). With v4 applied the bug is gone, so:
>

Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
patch, we are no longer going to sleep for dropbehind in `filemap.c`,
do we still need all the complex logic in the block device and file
system layers to move dropbehind to a workqueue task context?

> Tested-by: Tal Zussman <tz2294@columbia.edu>
>

Thanks
Barry

