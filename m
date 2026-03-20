Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409A1109879E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FA06B00A5; Fri, 20 Mar 2026 12:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836BC6B00A8; Fri, 20 Mar 2026 12:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D436B00AA; Fri, 20 Mar 2026 12:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 638276B00A5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:06:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18DCE1B73AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:11 +0000 (UTC)
X-FDA: 84566918142.26.E9C227D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E744F140019
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=aiCVXTkj;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.172 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmXHGaQzfs+IJLxwCsEE0bxv5XGFAsVai52fKs2Msxw=;
	b=3YbZWKGZXercJuVxHIn1b1tApsfNLTuuMnb9mrfQbjwrH6SX8GykvxNj9SEuNeQDKWbj6P
	r2VI9sKYbeyZV7gVCTLgTe5p+lfWzGaN4z8OsAccSN7Wd3d8MnvcocTcUSkCe7zMWfWsRS
	VJb4GQzIPYUuwXSBmOqIlly9TbNG1lk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022769; a=rsa-sha256;
	cv=none;
	b=BdgdEcR5RRxYWKhpv7hm01C4taIuiw3GlW/zOp5c4aSnuKz2WyTVLSnEuh9+LWaujVnBrV
	s2iOjZoOFDTRT4MO9abgisyzqksHE/WqX/BkC5KX/nXIhlCT97pW12paja5SsbHnSmQkAV
	kElFY5daXAf0DCfqUt150WNPJHoLDLI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=aiCVXTkj;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.172 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2addb31945aso13754325ad.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774022768; x=1774627568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmXHGaQzfs+IJLxwCsEE0bxv5XGFAsVai52fKs2Msxw=;
        b=aiCVXTkj8iR0uh2cWIviVYW64pMF/7l83/iRw0MeyVj9exRYGh/EGwlAhjPYMcUZX7
         /ACU95+W6z5QhaIveCJ1OWxzKJ7/QM4nwvwdoAsPPqSaL7yR4Qe/+lqOpcf+0SWGmmEU
         nwDosdmIreVJ2HOHOX/p4HgFS9m7X54+3JX4TaiFSZfh4tV70KLwQoTP4MPBYhtftExw
         4ejLpd26ClH2c69podIdrGWGNHLBpoxvnvXOTjCdhUrFQnMVYrXNAnKrwrClG5LqD8MV
         6RTBCFEWpFOB6AR41GDMPVlvRW8H/w9E7dSB8MN/+1+VqWp5iouo/Yw7f557BkM1nfbL
         UG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774022768; x=1774627568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MmXHGaQzfs+IJLxwCsEE0bxv5XGFAsVai52fKs2Msxw=;
        b=IUXEeo6DPo8conaQpo/pQJ67sw8RhIaeX10+F1LmETXQIDPWlgYk6ShbCFvl5qfXh0
         hdq3tpgM9kAQYuXj0QnHukJvwl2Upg81bHLJlpMea8Az5ewb718BlDBCRGOebfPT8qGN
         Z8RArFIVhlx88FaXxujk5JVzf+2a2WFQ/fi2Eby5YZpB7mItX6SmIMmT2Nb8WWNmeHn7
         zy9CAf89dEbNctz8EhQWUqO+aUTMbtzW9gmMfminXzcgXoqT0qHH2eC3RoZEM9Suyymy
         fAAD0QIRkwGue2r8WE92soK3J2siwaAs3BsJmZ2Fh/eQIQzOc51z8M+AijR4gSe2Q8E9
         PEWw==
X-Forwarded-Encrypted: i=1; AJvYcCU/oh33BESYT/zEccEoIBhzsDjZeJ3ZnFsNmHTlZPEElzoQstR0iaJVOd66RQb8qo+KMTqVOB5+TA==@kvack.org
X-Gm-Message-State: AOJu0Yy3ex5zhcOs4P3oYw2GZQtCBdMVQRmPW3edZWnG0WFJdPaMEk5c
	jDpgoToZ68/giyeLEtT52tu5ciNasqVKk1TdHWwk+C0dlO6T/PcuEH5EFKqJWO/Ag2A=
X-Gm-Gg: ATEYQzyQTb0FaiKylReJyyBaZ0iTc0f6IE+PZbHb5H3IgIXGrD8ikiG5htZlf1m3NLU
	VidHHnTd1NDLrJ52ArEsIzpZ9FCOlobngmWcf8DM9000uhEzlPB/gyT+zPerT9navFIE+f4M/Dt
	Lt5Lc2OVeCiu55L+HpVuUxHo5CPlZbiGQoV2OpgHuTBrN3JTF2XNgQ75ZYWi/SBMqRxlaowEs7O
	vLu+9ZY+Nx1mvYO5gexoM7nH5lKbRXRQiw/syVJ1YyTGPKhwaE6Q8yDqxvqkCbuE0N5Q6AjZsT9
	io9mN1NA8whvGuxFNAkG6bE/ntMQQe27V5VLOxh6o9ggi7VkJ+hfjE+RYWqE5TeXvVntwT4oqz7
	jErjyLJNJgP+m3nlPzgTYDmTlRPXrX8nj5GeqoCpg4fgmnO/xmboFuvmzz7/deAr8/BVzEAGSno
	HC
X-Received: by 2002:a17:903:22d1:b0:2b0:6e8f:8e85 with SMTP id d9443c01a7336-2b0826d73e8mr36730865ad.5.1774022767505;
        Fri, 20 Mar 2026 09:06:07 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083656b51sm32785625ad.54.2026.03.20.09.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 09:06:06 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.l,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	r@hev.cc,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE coalescing
Date: Sat, 21 Mar 2026 00:05:18 +0800
Message-ID: <20260320160519.80962-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320140315.979307-4-usama.arif@linux.dev>
References: <20260320140315.979307-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d4tznj19xqgx6uz6xebds4srf51rgsmo
X-Rspam-User: 
X-Rspamd-Queue-Id: E744F140019
X-Rspamd-Server: rspam12
X-HE-Tag: 1774022768-566340
X-HE-Meta: U2FsdGVkX1+nEeDi1q5JL9YKiZAPlKUePpOpy4bJK3iojCuapi9RsXOBql0tTpyti2Lq0zeae6TxaLnHble4NgegOHP/sBKGCwJs9hiKwwV4YlsFOLR6g1yE3Q9ZEjB7DYHo6VPUlV1jp2xG68GEkt05wa7Z3XFSqCkzEI3NG7MKMbFe0vkRyWwLgpQR3iRLsZSqHTVdIqPZXNiMVUTPEYMSubzhtzHgsBplIoyrniQeEHP4OMpvu/mYCOeZXF0AumrqYBGT7BBT/6DwwobHXuE0pi8k7Q9RmLbp/JKO32e6IRwVpFz43fzy/mBirjDzE/fcAo68VAzEMRYHAtwT6cBjRN4Q4ID0f9BCY1vCO14AsBEmMsBNu3qh4PRAtZESHlu9ZOIh2mAg6NUXGMw1jBGW8RO0cchDpLitLAlMJGnqk5L/9WPtcSpPmP2q4D1Mv3I0mLD8XxpccIsDLpyxD7fwSZ7f2bTqjIIbBJ6R7lTFOXfh5PK8h1eDOjLUetuNyAx6EEd59eP01IlnVo1qm6XN4WljXrGVQ/zfRdror1GORckcnakVcJNcgPJD6jk0GO1jTVNa745ZlwX0y3RzzYnTtsfIccSSYfwSmFU/bwTvJG8xupJQU/W+pMrG0L2RyaqYtcMEZVG0MzJeKSibX+RcTeLhhI8RjyBQwZ+P7JamSsq/ubo1WPNNTM0XQXQ6ekAMOvKVgKlb5ldQa743BHqpb3KGQKSpltAs/OVv5LqXY+uEED7ehT9u7vi9LpvvoTKM7yW1ynCOivmAbK6WtczglFk//9Li7VcZClVzp5w01KMdbunePo1dIZxH25tKT2ZCYusLGiqUs246wxVS8neefUs4YygfOkQn56UJUSa60rmCm+qPZJPCNBAN9eeEgn+WcVncnbIeiylHLdegrO67+PVXN7G9+0TD7jG4wF/5lc96WhQm1nvQkHomZ29pA6SFrAmhtY0j4ffA5lc
 0BGneESy
 +ztcqoTQKL/S/5LHXFcHzvbpVjLDe8KX8OFF7qq/L8gx7v78zUQXAXJJlepphF9OSfoII3xD83WvHOAU+0S9Vu6/t16cJ3MmbECcfn08RLMFrGz7Ge3MPUlox6qBG3fVuRGQXHWY7k9+5OpOIeOKv2/xVDKojjz5LgyolGkd4NXnWhYK0ui8CNsBxCEodeUeNlkbHq8IJpWt3IQ2BVgkRJCtQaUEkifBRaJZuCg9MHR/N60HEDWPF2lFA0b28BId1LwQbY5l4ga9jwcbeHYLs6urj8dBt3HTSZ+O6Uk6nEVGm2mh8/opybmkcGEjmfduJZVOWSibITlQ+3Tx9qWZCfrmA6NEpxcqprpbDm7gU/Ia7kI7Td6s4KFwoFlHZftnZyAX1SmCmfUS0inGVOYZRwFz5c8glKO9JeGSOFE0cVCw6lCOsdTQcqJu9ORI0ylwkvVOn9pMMmasjZ8Eezq0nfKfqu7KXPiXSxCIUDvTW2mQI/eMc/98VGrd5GH6fc0WarAb/rnmZk9XJYjBizp9ZDUdj922E7JG81te6KfX+5tA8p19yBP4qnfXtoEi/ewBRkvke6f7cebyLsRzsCpnpuK3P8BI9vdFnT+Hs8Cr2f4QTWrPZgaHDWfBa8SDgu5MKm987
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On Fri, Mar 20, 2026 at 10:04 PM Usama Arif <usama.arif@linux.dev> wrote:
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 8e89cc5b28200..042af81766fcd 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -49,6 +49,7 @@
>  #include <uapi/linux/rseq.h>
>  #include <asm/param.h>
>  #include <asm/page.h>
> +#include <linux/pagemap.h>
>
>  #ifndef ELF_COMPAT
>  #define ELF_COMPAT 0
> @@ -488,19 +489,51 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
>         return 0;
>  }
>
> -static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
> +static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr,
> +                                      struct file *filp)
>  {
>         unsigned long alignment = 0;
> +       unsigned long max_folio_size = PAGE_SIZE;
>         int i;
>
> +       if (filp && filp->f_mapping)
> +               max_folio_size = mapping_max_folio_size(filp->f_mapping);

From experiments (with 16K base pages), mapping_max_folio_size() appears to
depend on the filesystem. It returns 8M on ext4, while on btrfs it always
falls back to PAGE_SIZE (it seems CONFIG_BTRFS_EXPERIMENTAL=y may change this).
This looks overly conservative and ends up missing practical optimization
opportunities.

> +
>         for (i = 0; i < nr; i++) {
>                 if (cmds[i].p_type == PT_LOAD) {
>                         unsigned long p_align = cmds[i].p_align;
> +                       unsigned long size;
>
>                         /* skip non-power of two alignments as invalid */
>                         if (!is_power_of_2(p_align))
>                                 continue;
>                         alignment = max(alignment, p_align);
> +
> +                       /*
> +                        * Try to align the binary to the largest folio
> +                        * size that the page cache supports, so the
> +                        * hardware can coalesce PTEs (e.g. arm64
> +                        * contpte) or use PMD mappings for large folios.
> +                        *
> +                        * Use the largest power-of-2 that fits within
> +                        * the segment size, capped by what the page
> +                        * cache will allocate. Only align when the
> +                        * segment's virtual address and file offset are
> +                        * already aligned to the folio size, as
> +                        * misalignment would prevent coalescing anyway.
> +                        *
> +                        * The segment size check avoids reducing ASLR
> +                        * entropy for small binaries that cannot
> +                        * benefit.
> +                        */
> +                       if (!cmds[i].p_filesz)
> +                               continue;
> +                       size = rounddown_pow_of_two(cmds[i].p_filesz);
> +                       size = min(size, max_folio_size);
> +                       if (size > PAGE_SIZE &&
> +                           IS_ALIGNED(cmds[i].p_vaddr, size) &&
> +                           IS_ALIGNED(cmds[i].p_offset, size))
> +                               alignment = max(alignment, size);

In my patch [1], by aligning eligible segments to PMD_SIZE, THP can quickly
collapse them into large mappings with minimal warmup. That doesn’t happen
with the current behavior. I think allowing a reasonably sized PMD (say <= 32M)
is worth considering. All we really need here is to ensure virtual address
alignment. The rest can be left to THP under always, which can decide whether
to collapse or not based on memory pressure and other factors.

[1] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc

>                 }
>         }
>
> @@ -1104,7 +1137,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                         }
>
>                         /* Calculate any requested alignment. */
> -                       alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
> +                       alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum,
> +                                                     bprm->file);
>
>                         /**
>                          * DOC: PIE handling
> --
> 2.52.0
>

Thanks,
Rui

