Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4061CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 20:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BE3900024; Tue, 12 Aug 2025 16:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E35A8E0151; Tue, 12 Aug 2025 16:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2AA900024; Tue, 12 Aug 2025 16:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF7518E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:50:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB024160113
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:50:28 +0000 (UTC)
X-FDA: 83769298536.20.272F3F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A8F1180009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:50:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KRl/iJEE";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755031826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7YvdQwB8rttbhsO1577uV1RViiXcc8diXFNbqrfJYg=;
	b=GnSGX2t2wZJoag6w+S0dRQZdTTiiCRUDpEVt/l0qqkEJjOK2suTtmIDbLFToq7qDD+sJkK
	VJ3151qbwUYyQ/E4+g01FAydIJXvWecV/BPRCcp2VJzPLpEhxc4BJO0mmFfod5ukxxPHQ8
	7Ns3QGhdVfkCOxLHFAz478qUEmWlt50=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755031826; a=rsa-sha256;
	cv=none;
	b=dARFOibpBXR0zSoEldARDKQ4Na1SIGg7x8Z96mKHTWBRf5YcU4qkSYvpcbjwRhNa2P71g1
	CHdG06KTWXp7T6OElnzGHs9Fu8rI5m4ZDznkoLzO00EO3wnv2W4I3yWVjNSwbbp8j0tydJ
	nfz+hQ7YErajCiZ5DzZSk+CBob8OIHw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KRl/iJEE";
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755031825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i7YvdQwB8rttbhsO1577uV1RViiXcc8diXFNbqrfJYg=;
	b=KRl/iJEEiqwz+B+lRRT1HPFp9XNmDt2aM9zex7hJU+W28TGCHkXXyD1TGe6lVJw6hPXI7U
	FHNKXmJX7zcaiUj/G96Bk5xWrzhjAUohszDdL6QltRVGsrJgSGslEWrKR4QP6Cedt8SQYj
	D8qwYysvnAa6i5MWpGqYuIQLkMXOm4U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-S9BvD2IePgKQlx-ndTi65w-1; Tue, 12 Aug 2025 16:50:24 -0400
X-MC-Unique: S9BvD2IePgKQlx-ndTi65w-1
X-Mimecast-MFC-AGG-ID: S9BvD2IePgKQlx-ndTi65w_1755031823
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7886bfc16so3735649f8f.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755031823; x=1755636623;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i7YvdQwB8rttbhsO1577uV1RViiXcc8diXFNbqrfJYg=;
        b=v0bf9E27WGq09wnp+igFOaJ3GllMgyNxp7B5r7LR55pdabapQWWCevCrtWQ0HgfHK6
         7YAlHUD2kw1z+t7ssnoLm5b6CTOQYswWhkSHcr/zO0PuzngCgHgm9ExJ1lJ8jBSvYU4Y
         4XPxjUC6897Ixx4ex7Y6HTnXJ55mUbP5JtI2pZ063/oQyF22jar2/grDhqwZuY9MivMr
         VmsOnh8IhxxBKb9XUhSYSvH88wWGT4RbG7lAIEPUTlP+2cK6ve+wuVOJXyjMTawxmJW+
         ncR1A3SIS8G6V4ZU9WLPvxv++DT7za6P3NBuDDz2sj/WUFJOnzjvtGz9znA94uFtI25X
         SIwg==
X-Forwarded-Encrypted: i=1; AJvYcCXft/US5vhRkxUlNsV/jNgLgT3ydlAbv86QXiAb+CXLoJv77kPIPyP7AvH7sP7b0pg3oE7+hX3lPA==@kvack.org
X-Gm-Message-State: AOJu0Yx3/phDLqvu4E72GUtWanKVJifWzF1VF1D/LtwK1RC6ctw4cEp/
	L2P7WdJW1z+zu9sFXnRTrQ4MC357dd+YbQyk4Hp+ycjWpuI2JYGHgsNnXr1+zKVqDcMXXRezNK9
	5ImgonctZE0sZ9WjJqxJ8Ngy6eG5OBi09w54Kvon3i5RAqvULqdKG
X-Gm-Gg: ASbGncszzeviMtUWe4DeIRJowZa1meBfDFvaaCwf+9yXgTsUkDN/CYR2xIFwHj80CKk
	ev7t3o352AR2h9PtIpZBVrBLupJjMtzwCPLaj3LCgFFcdSLoddxquuoMHmGawWD7abArwDxb806
	yrVoz08Gi4+LCA0AgTzLmG5YmAxaX3XQiVExlMaxVhmfb8pTUlrWwU+ajJY5sxYxABXY9E6xB/N
	ux9U5Xzol+PiAaAuWBq1R9XlHE/rbiMjrSxmQa/s9Rr9OGJ5qAO8KEQjCNlSxjVBSs5Odpm2neC
	cHK/6lb+7Sp4Re3nKKj99tRR9OAs1Efh4wNYBGTUN1C4mLml6Q2Qnvtt4ejhSVGUphHmEuTnItS
	xIspU8jPDTbokFhllH+km6WG/1Y9kX0tEnjGaxP9TBCVy7ToiBHTGrZ14mUB2pSst19s=
X-Received: by 2002:a5d:5d86:0:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3b917edd49amr261525f8f.52.1755031822692;
        Tue, 12 Aug 2025 13:50:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSNykJv7Lvbr5f90XjicFITMJaQbu0/2nFACy0ZV5jZlmNVRbBlprfnnGCdefBalsMmuBo+w==
X-Received: by 2002:a5d:5d86:0:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3b917edd49amr261518f8f.52.1755031822271;
        Tue, 12 Aug 2025 13:50:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0? (p200300d82f30cb00c4258b4bd9adeee0.dip0.t-ipconnect.de. [2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9eddsm45439761f8f.22.2025.08.12.13.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 13:50:21 -0700 (PDT)
Message-ID: <0c96fa0e-6f7e-4cca-8d57-f3e3786d44fa@redhat.com>
Date: Tue, 12 Aug 2025 22:50:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 101/118] arch/powerpc/mm/ptdump/shared.c:70:1:
 error: use of 'pgtable_level' with tag type that does not match previous
 declaration
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202508130304.5FJqRz2c-lkp@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <202508130304.5FJqRz2c-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3opEVOq8j9-ZSqFiNnQtSfCV9OrE3E7O4xl2gHOGm0A_1755031823
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A8F1180009
X-Stat-Signature: ym5xmf5wn8adntfh6u88fj3ka45qomra
X-Rspam-User: 
X-HE-Tag: 1755031825-37831
X-HE-Meta: U2FsdGVkX1/5ey7rqwWfz47QTrpUWKaqM61BEC4YH79vJQzLTWQMT0Zp6/42OCQZoveVuC/4Pfca5ei3OC9c7oPzgbCnDGo+1vbOXL2Oo7QiW4BAJrYyBvYH3Zzj4/iWRSFAB40nIsNtrhQquRvGDw/ovpPAqGpZUoxGVy2lYOrZoxnQumZrc8C21n7S9G27xxj77+yPjOwvaz0FUfvqCqA+MU7nyvFuEDxv/49CGA1Ig7ou1A2GHZP3lUuVf4Aa8Vzn7d5AuaVfJ1dmjYI1LZHXp71wjPK0OqkPvN5dwUPQNzugN6dsrWI4D/BGETIGlpNCPD6Ofxa5AtbCF6SaTykH+UZRpLF46vP6d5z2COEixtqFqw2kgBMn8VrEx7hOD/k1Apl2uh9maCAUxxGPi3PuyJ3KE2ZSqMbe94itcLvCjB5qOmRsR4xwEfgbOEE+72l+Gdyy2+54tm6b+hl4RXWUe3r8P1wUT8yAryscwvBeRLuasMXIh/lL9K0QD6dqv2AnAlUloiVORervJQ+E8VKHs41cYqc18qQp6b/VQpfQuZBeWz4DGiaoHkDNgFaAQ5spSWvPT+usapYMLkiFQzQSb6Z0c5SSzGqyrrV7WmCnJx8HH6Of+znuocmHPBRpOtgG0b5jDRv8qowK2ue7ebL5Awc6YLg+G+iXwF6PYVWUv1NWwW0xNrQdsRB0xrD0E7fc+BHywwiIW2EQUqLdVFHSwUrZpPDAEZ26Gzu3Uu+Fg2mRAk0OmwQa/CzxS8YevpsMEONWkQUPF+hd/jty7wRgc8bSedkgxReblH3oJOsvuScj96OUzstg3kB4PqrtlxN0Zl3ryiPAIhy+WChpM1Gn5xrFrvflQld//Nbhu9dNc5lKDMpx/qmWthrkbKs+HZAb5k8VOeJqJDY9RCmSpgPQpdV0aWzswOuncqpkUma2+r/ZuHbav+iLX0xCI8kINTwn7ZfoaLz9+91WO0G
 gmMF7T7W
 qYezSmxUseXHI8VEY7HJulF3QWUKG2JNFXaA4vtNkGhIbBbx7qhxSleMQlT9t1Zhhw19l8T0F6ECb0YFPXW9ONZ42W0LjZWuLfxQubCsQJDUCmddntdVoRQgfFBHYBhPKQXCfdl0R2fh/MXmbZfP2QoXpdkxwKb0/St1SH+AStS93CdVlN1Q03QtjTxuayZ8WxT05VrLvd4URfRD9Y/vWrcXd4DrAHDWMw3XS+pEg3gMlZSEmTJAbMbk8v1x8LMV/+5bqnjze/q7h4XZE6MugE+Yl7V7fZ44jd/LGNA3ipTbX3uG5E8l/BzZcUKPwzGTzjbyjuzTrD3syMUdvpxuZEFDnsgndll6ObtrwjI5ESONNrTLQiEpTezCsOaaOtYBSm1fWHIIonFyPY1m59CdKtwU+cycH+SihUOYolqQFseOgk/rQ22XKSna2IAbAvV25BkDGZPTKgQ6fahaCZ0DUn1w51eQTOZSnPk2kMTX0YBv3RCbHjAnpvFpAr+yTKH3KUjVQL/o1WH8zp4BKzD3sbFt0iznGDD+O09RO4teVrR4pe+j2QcT8ZzN9fQdh+p2ZcumaRPH8eFkkf0S5x8l4JZnliCcFb8qiqcImazidaPeEMgRPwF/okMZUncCyItu7tBxo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 21:18, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   33ad02f876604ac2990e510480b0ab3a03cf892e
> commit: 627bf62489a6d9a45f6d6f83edd0cb6c0ee610c0 [101/118] mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
> config: powerpc-randconfig-001-20250812 (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508130304.5FJqRz2c-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from arch/powerpc/mm/ptdump/shared.c:10:
>     arch/powerpc/mm/ptdump/ptdump.h:14:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
>        14 | struct pgtable_level {
>           | ^
>     include/linux/pgtable.h:1961:6: note: previous use is here
>      1961 | enum pgtable_level {
>           |      ^
>     In file included from arch/powerpc/mm/ptdump/shared.c:10:
>     arch/powerpc/mm/ptdump/ptdump.h:20:8: error: use of 'pgtable_level' with tag type that does not match previous declaration
>        20 | extern struct pgtable_level pg_level[5];
>           |        ^
>     include/linux/pgtable.h:1961:6: note: previous use is here
>      1961 | enum pgtable_level {
>           |      ^
>>> arch/powerpc/mm/ptdump/shared.c:70:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
>        70 | struct pgtable_level pg_level[5] = {
>           | ^
>     include/linux/pgtable.h:1961:6: note: previous use is here
>      1961 | enum pgtable_level {
>           |      ^
>     3 errors generated.

Huh, I cross compiled this on a bunch of ppc configs, but maybe not emough.

No, on the branch I submitted that did not exist.

Probably due to the rebase.

-- 
Cheers,

David / dhildenb


