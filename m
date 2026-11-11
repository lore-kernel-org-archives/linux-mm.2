Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E42C606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CDTIwWvo
Received: by kanga.kvack.org (Postfix)
	id 3FB406B05B2; Wed, 11 Nov 2026 17:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC7B6B05B3; Wed, 11 Nov 2026 17:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9FB6B05B4; Wed, 11 Nov 2026 17:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 105866B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:57:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A01F11A047A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:57:39 +0000 (UTC)
X-FDA: 85424351838.16.1756040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1638240004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:57:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDTIwWvo;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437858;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VT8DgmyydrVCsq6iQ1NGHQ1X/1hn8WI48WKI7IR98E=;
	b=Qe+sWvNLzos3JHxHImzO1r2jEn9JQfLEzTHD0XOPwp7HP6eph2Xp3DA5zYYdkrwNYOjIn7
	M/vl7PeLC8fVPHGky3xW92xZDBY4EJuVnSUddBEG/XXIaTcEgVVC99tXZ9K+SCwR9KAAuI
	sc8LUk+w4XO6zuHRN6n7AiBwSPi9TOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437858;
	b=I0DTTuRZAyBR9h3sV+uwVnYAygkaTzTVMYfSjO9E7bBEThgFQJCxG66HSR3BHIa6d4Ij8/
	gkE09hXjhEFzF0D/GdWv81oDcUasqo/aAkSMz2Exx4m4K5Dg2qYVaNHfWY3pP/POviZqir
	jqhd3Qhzd6j6j4PNs1AcVrfHPyfvA8A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDTIwWvo;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D556403A6;
	Wed, 11 Nov 2026 22:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA38C1F00A05;
	Wed, 11 Nov 2026 22:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794437857;
	bh=5VT8DgmyydrVCsq6iQ1NGHQ1X/1hn8WI48WKI7IR98E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CDTIwWvoKVuz9EvFiLSeUU7OhIpWhOk1Dm6XCV/YqntGUOVFTjalLRS0P5ss0T0cO
	 oAN4swuWMJsWRFCd8KMKph9puvu71p/2LEklrnKK3xeLluzU4OXy+2QzBuOzxrFn2d
	 n+gCee/pAFa7Uk/VT2SKdvpLwdh55N+KSasGnPzN+sTMnVTNGW1GNWeVVpu4Q5qNHH
	 BnC+0HAggvXNQtVWDYL7dS+KPPfYc3dwO/Q+LwerwM9Lk/6PYsntJpaNtQVZt9PE/F
	 hUUu4tJCNffScB4hR8f9kShYMPJ4vFQsad5uZWEnQHq/cUdNXchIaumAz9xdfn4ZZJ
	 h9VHZUhXG6LHg==
Message-ID: <sashiko-outbox-209838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] shmem: Serialize fallocate progress with writeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Jun" <zhujun2@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: hughd@google.com, david@kernel.org, baolin.wang@linux.alibaba.com, linux-mm@kvack.org, syzbot+aae8bd56cc1c38d50ec4@syzkaller.appspotmail.com
In-Reply-To: <20261111084155.80971-1-zhujun2@cmss.chinamobile.com>
References: <20261111084155.80971-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:57:36 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oo4zeo4n1qamr9h8rbd8fbx75d6e8cq8
X-Rspamd-Queue-Id: 1638240004
X-Rspam-User: 
X-HE-Tag: 1794437857-940875
X-HE-Meta: U2FsdGVkX18DBOTQ/ALqmL1gIEF59Io1B19zgovPEI9u0d9ku6XzOBOEHj297mv6uyPUrWXgcDhocMeuslCl/dq34UhoQsDwQKKHyHPTrdtRzLmV90MOLQ9gAUQaO+lWThl+0vk8TAnZ8mtjJ/89cq0Y5rzL7eRpn+S9gUNNrRj1Wr5g6ZHVNda47oFXN0bpkzHatNmu7tNSzPLZg/k9cHcq81C7GGQtKUZ2yT3xS8ShOrjHAo2ddJ7U0Vd0ykeU/EkZF9Lo7D5JkqkbhEK9UOdjGdFRXQa/uNymAEDtdxtpeuf7ubYzYzS6+6Q7Q6iir/StyLIprB9vXohxU+u7OwlaA++6XlmKM1GpoHG/to8q0yCL60Ry15jSG2T1Yt7z7Y6TH8HpxJ456A8z2drRiVAST+6bOSEgl73nv12DfSJ+cuuyhHIzcNHMh7GOJKqR7qQfF9AIZ0KZVCvprXFe6/cZjVu+mz7yB4G4L6VwROFUeCGu4BdR60sSCwq/T1YjopIcy4dbPCAD12zCHvVIZseaN77vbNCcghHx+Y8IXMMRgrjsFOtCfBXWFON3LfKjkL43eGGixvpQWuClqLxwm+JE3dAnAb7MJcZnHQMO1dwmfCxBhqxAu8XUkJcYhAx93xTf2r102DfWk38FFFPPXBLszGjbVpMFw5PNALHi7vGQU83ABYTNoQuZWw9drNNMFGXEBeTUaLqMGTxlPgVCHwpBE77vqzUFGwZtxTwRSFczS5Sfx+ZcWWAquUaXhUmm8QGfItbcwrOGgi/g94oXlYlIBbBdJT19F4lNpeO7h5eI5lzROEmTeilhD96G+VPqM1jkNFIH3+hE9a8SrjYUst4Ov7RirRRZ+KVtm8Oq96PnouUJyGpW6ZwShY/LLmbjs7Kqz4VPHO6q4sw6VeJ1Rn6077162STWuZYxE3tcbfPyRt6/vpzsaO3TMWBnxCcVYjdF/IRyaY+3AiF+py7
 XtF13Ji7
 72QWg8ruhOJrat+SFxkSamKH6Ko7I1PvC3eplaZ2xXa7wIwx0St5aKFWiwNud/p3wG4AYU/tfhfHE1KGfDRW7F9mSLQb4p0pk5CZtzRNpJ5YtxVy1H3fuZJBFkqAsemBBeCVAOQLf8hWSij8RK0Vp0q0+8F+GMniz+3PKo8csptIWmVUHK5wMImVilWY9MtdMQ9swEW5SZJL+/4Dh+A9c/iV35he2zjcP5MPgQW9jkD1OA9usCXlzQ7dFT/MO37hXu/oFXo04yWi9Kukw2LnmWm8dzaVyJS8/1+xesyA8PWIU+4I3LZQCbybxC+0XatyiSrUMCop3xedEfXpfP5g5K7Qf53FXF+UcmTTkwKndK4wjrdxYCU4S21kNGy206h/hmMNw/NZFSNhMxKj4bq4kFFpw0/907O8ZqtzPytkd7nScE1jNiWF2OhrJqRclSV1FibSFlKsjf68n3sxBvEcQeNURrCkMVCSSPQ5nAcQWdfhQhEkZWx4TxW0oRyOBljs5w3CMvaY1hnAOLIdqIVvmWt9U4h+kdDExb9dJ4Fe/249LBBlKbGp75m3rz4LQyN9p70itdK1MiCcuk99JB4mxz9WBeBUBN6DCylhWDPNQQv3URTwZ9aC6UJ41qhW2tGKY/z35iWb8lZoBBq44+p/vb9eDb7+LFpGBdZFGKYw75fi+WOoah/cR1T/S55fsMBaYl5OVDEHA0q+frqj9s1kU8bmgCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: shmem: unsigned underflow of unmap_end in
  shmem_fallocate() [1]
--

commit 9946039967ae29ddb921f16d447ade65e0f1335b
Author: Zhu Jun <zhujun2@cmss.chinamobile.com>

shmem: Serialize fallocate progress with writeout

This commit takes inode->i_lock in shmem_fallocate() when reading
shmem_falloc.nr_unswapped and updating shmem_falloc progress to synchronize
with shmem_writeout().

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4686875a3adde..219ac18aef915 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3981,6 +3981,11 @@ static long shmem_fallocate(struct file *file, int=
 mode, loff_t offset,
> =20
>  	for (index =3D start; index < end; ) {
>  		struct folio *folio;
> +		bool unswapped;
> +
> +		spin_lock(&inode->i_lock);
> +		unswapped =3D shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced;
> +		spin_unlock(&inode->i_lock);

[Severity: Medium]
This problem wasn't introduced by this patch, but can unmap_end underflow
when cast to u64 earlier in shmem_fallocate() [1]?

mm/shmem.c:shmem_fallocate() {
	...
	if (mode & FALLOC_FL_PUNCH_HOLE) {
		struct address_space *mapping =3D file->f_mapping;
		loff_t unmap_start =3D round_up(offset, PAGE_SIZE);
		loff_t unmap_end =3D round_down(offset + len, PAGE_SIZE) - 1;
		...
		if ((u64)unmap_end > (u64)unmap_start)
			unmap_mapping_range(mapping, unmap_start,
					    1 + unmap_end - unmap_start, 0);
	...
}

When punching a hole with offset + len < PAGE_SIZE, round_down(offset +
len, PAGE_SIZE) is 0 and unmap_end becomes -1.  Casting unmap_end to u64
turns it into U64_MAX, so (u64)unmap_end > (u64)unmap_start is true and
unmap_mapping_range() is called with a holelen of 0 (or -PAGE_SIZE), which
unmaps all page table entries from unmap_start to EOF.

[1] https://sashiko.dev/#/bug/linux-d9244c37-209f-42ee-9567-f317e50a1be0

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111084155.8097=
1-1-zhujun2@cmss.chinamobile.com?part=3D1

