Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B073606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hEm+tm/L
Received: by kanga.kvack.org (Postfix)
	id F1C626B0385; Mon, 19 Oct 2026 17:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA68D6B0386; Mon, 19 Oct 2026 17:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6ECF6B0387; Mon, 19 Oct 2026 17:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A41DB6B0385
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC02FA8542
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:23:57 +0000 (UTC)
X-FDA: 85340653314.23.1008F38
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id C35FEA0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:23:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hEm+tm/L";
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445035;
	b=4KKx+sOm7UxsW5zF0gOHr2bsPwQfD2/bAAjoyh3rypVU6O48J6k0fIgGTsFdRegt/PBj0I
	+K2h+lUm06bl1jmF/KsPl70r48VrGaP+YnGYTvIY2Dl9ZjO5h8GJ5JUZo/idR4Ej1nCRdc
	tWYuV7UuHtJVwtjGpTEHgfBrYjrqFws=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hEm+tm/L";
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaSAtodmC/zEZWFNfit/fgpW8kKnO7aYgRQp3aEBxrU=;
	b=c/qxzsSw91enPk5e2Is6Rs80pmK0eSCKlTPR6DZ3H+FL3JrWdG1RqGA1ScPGs340NSqWI2
	yNADC2wBwSC+LChp/J+o32lwDfbz3U0C3sVIxE5M7Ewk+KcOI2758WceNIjDlRoSh2ARkJ
	At4n+u/zJHCn6QVUTVy3i/H0I1/IOII=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1df146015so14251135e9.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792445034; x=1793049834; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RaSAtodmC/zEZWFNfit/fgpW8kKnO7aYgRQp3aEBxrU=;
        b=hEm+tm/LFrQY2MRQzsxA8+CaE0v/+hQIzTgn4UpvsG2VgOl60pEQBxdUetw329oGAl
         v9XolmsHtcpxzvnJsbnI0V1ffx13ijtliVh49JgGaYYy57QKGW2aDSRbHJE7BD9Xk0/O
         gA06I9PNdjMV6rCpz4U2Ba4UrlkiQV6lRqUg7ckl2DIIzwpp8CnxzNlkfY+6TQLMDDyx
         tV/S3rYtfSLhKEohPBgcFYGOBLMtYvv01UI3Ecy9i0k76Q4E1D0BJedYWjqG+V0dllyM
         lg2ml57uCXKDPm0suOxBZezZxw3zAQ8mVzVWWUvc6kxtIkXBrzYAy/uZeNUz76EZPt9h
         FheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445034; x=1793049834;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RaSAtodmC/zEZWFNfit/fgpW8kKnO7aYgRQp3aEBxrU=;
        b=nbaTKUnr2Ko6M9On1vNZTzDVOzGNq2wvZxlQG2qvIPzD09LNsi00ZjXby7kmfn8u3D
         bcG+j4Z69nzF50iMsBhwPFqU79Fxhp4q0rgTQHdHaC5HXlSLhhYp7ZfZYbtKIsHxJv5b
         5lhnQT3Z3xfxoHlAEZGEiL3yH9qsefG8dAqvSPv2Q60BERAXfAiJV2E3t5OL5aS7cgvx
         iQHntfJpb9fnA/bD1OfsDzSB2Kph1E/Tn0BRnzgYnb60FcA0I4sVQ4hMbkUjAEWiI2lp
         3qfkBM7bEe0EoJ9kp6Ff5RRyMs+Pfs73Psl3CWIuciiruXiN4Th2RT2dF1i2xRPDR7fS
         97GQ==
X-Forwarded-Encrypted: i=1; AKwUvBxtsZYP0XNnGrQZt/jcE0POlLzqSB2CQImqT1uw9VCzvzyuFXfI682LlPpUc0d/EM8h7Nrt4DWIXw==@kvack.org
X-Gm-Message-State: AFq9FYJr6AqqkjL1HeSb/CBK1JeF8d6tqcguxsSkFZSUTKG4Tm35acf6
	+4FQMDhHbRXSLkcbMWG6vmAVMIqFpR6m9mQnZ8D5PfRdNwPpXS8KHnsD
X-Gm-Gg: AYBFou1weZ84XB9Lhgpi/oI5Duk4asVIme9qdJwg2yGUS1SaMeMy+qHGDoPjjyY6kt9
	p4S3UzSOLMqjzKRe00Y2ZLvih0Ee08LaFVKftuUyAZvm3W7+pbpPVG7tA0luImPDobOraFrizL5
	a09Cfy0a4I5MB+fhKQ4mQGui0seB70VdnFMBgaMWjuQ1kgzhTcmN4JApEB7MgCKpYWTSNrgIPnP
	lkEdxcZ1SnbQ+/xiHHXX8kI3p+ZzU3w/zOZsV/WuMuFTRbMpTuz7dyldrwcygjhHA/q2YSUreQj
	bDDl/U5Uuiq0g0BiQD548TIWjB0upZkQsFleyj54NEx2Y2knTBl0p01X1+1w2fom1wQeuQ/rz9h
	vQWbwH7lBfIxOK8+2xzpgutNIwXaHakAazwg++X+0NHVwEWP+/hU5d9ud+V05m9ZGMweCaeT268
	Iocawft18aaCnhtSByCEGL03xcT2c0sWsPJ0aRygHezIasH5P6BmrUoz6XPgHP6dbOG94QRvAip
	Oihduw6/9q5IAPhmiGb9FtJDPGr9mkX59w7m3LKvbmT2A==
X-Received: by 2002:a05:600c:e549:20b0:4a1:811c:8078 with SMTP id 5b1f17b1804b1-4a1d7624601mr116807835e9.26.1792445034012;
        Mon, 19 Oct 2026 14:23:54 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1e2def9ecsm97956265e9.1.2026.10.19.14.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 14:23:53 -0700 (PDT)
Date: Mon, 19 Oct 2026 22:23:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek
 <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
 bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>, Lorenzo Stoakes
 <ljs@kernel.org>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>, Luis Chamberlain
 <mcgrof@kernel.org>, Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 14/15] kallsyms: scripts/kallsyms: Reduce the output
 file size
Message-ID: <20261019222351.64bb9d35@pumpkin>
In-Reply-To: <202610200336.6v4SE96n-lkp@intel.com>
References: <20261018155206.132411-15-david.laight.linux@gmail.com>
	<202610200336.6v4SE96n-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jmcp691535q5xh4rhh5anq87eitefayr
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C35FEA0007
X-Rspam-User: 
X-HE-Tag: 1792445035-13794
X-HE-Meta: U2FsdGVkX18jKfVZXQbrfiyTXsZnLBhmzUSNdJ0/Ru05VQStWTHY/Ijw0fo8uPm7Bts1zckHJwL5KKsWFt4iDM0R0lTe3hVKKFIqO2GDh2Li0FRegOz+lnOwIgTTVL///rkTr9SChy1Qh97hnIsJ7na2fbQhV9/CTLOO1DdA/C46scrv12ar3cRvZ9kEKaofcK/FMchC41/X2frxaXZazNaSD6AiUCnz/LvjUh4CZwQf25sUSnqp9DZ7LyQGc+rPdVtSmVM35Gi6v/ttlB3kv9LhIFwco0FKzSEz1I9y2MMwVejnXgUalxjkAYrhmiJkQF0yvfChMgllVOa/6bbz7YtfYxVukuCnWekFy/994HWooszEHx/gzITPmkY0IwWwtuHzWQ/QbbwU8le2o8KvrwcYLdGL6lhAqabOofCTrclfSvMrgJy6S6Xr5OIvPjSJWXRndBVI/OfprVSByvkBV++SCui3dhhsGMpxnoXPxbpqgZu3Z249npVScjmRQywnbQgNH8QB6jG5EYmXfj0jp4W1IZ/eZNJokb6JXAf1k9ZHVP4wQPhAC5uOQJ/dZWK7pOTumprWPoyvBclmDqpmubkMZdQTB7zmuMoWNNEQGBiSl4cf4gFS2Z+xsaxowEr6uysuHchXqKelBAHZrlu2Z0ExwlinYLGoLeUxApvv2+VN2O+MP+CKSaHLJrmG7dxmJakmbZ4tk06RpfZzhrDFd0NY5798OUG+YQuCa+MiAM1C5/V8T2t+pgDJHCyFG+9+VLIPaV5jANHKA/A7rgdNl/1ueug1mKAl0Octg2E5JfI0eo3M7Himn/GdS9UPePjh5F8mETdEHt36BQJZreM7tqwZ51lEiJHNmKWJvfOAZBL2sx7K9b/hOe2A8h0qQpNfJEFK/6MSG5OWtBZihou0kIhXW81ly6XnTPQPBeI4t1wvZzCbTi56/Y6w0E/+yWeZ1Ol+4OtN1iLbogGufPL
 jgMUL7ZA
 8iVywYKme8zYjvEjTk02oNPDPoTu2MNhq9rFJ28r23DOSvtD0rwU1jsr88zhL7+Px4bpzmf8UsQ/Cjs5xXMqPMjkww3IQP1W/orYMV6Sir7ZlJHX/C2NtGvHESbr65fL6njwTTmA26Z7nlEzmRraesS4u6U3rOBPwZVqvkVC12z32XTFjbQjEuht9iHxSm4Kdb1IwNsn2hAmk/VuX9ixa1NBrrazmrwoSI/z/ooLAfeeM0rzoe/DgO3gR2cCMb0pzeZvmllzGPFbg1yl5qmkr6SWPlcYeworLE4E+l9RuQN/jUg0g4RU5BFEyi2bxqUGyQp8c3nsg0sFe+g7p3a0lXFtuF58FAulm8n+njvIrh1Dz1EqazTgVzWSCCsLZsJsBv6fZL3clNLJugoNDQq+TR4r+dUa9U3uTA02kAWsEV6FERLPHO7IQvO6ytP7kBqHoqb1GzlA19j+CD+CyUtEvoxqXlu9cTSwhc9i4EOuAtehgt4nTAe7dKIx7jo5c74PzTZdDLgyfOK0e9XXkXJ42l3FDovZC9HynN1nwclHYalEx1ypinLM2HodWMX1ZSor5JRIMn2ypFY9Ji55CiM9qp85muRld4vMNagj8opqM+1+0Cus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 03:50:35 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi David,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on linus/master v7.3]
> [cannot apply to next-20261016 next-20261016]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/kallsyms-scripts-kallsyms-c-Avoid-overrunning-on-stack-buffer/20261018-165152
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20261018155206.132411-15-david.laight.linux%40gmail.com
> patch subject: [PATCH 14/15] kallsyms: scripts/kallsyms: Reduce the output file size
> config: um-allmodconfig (https://download.01.org/0day-ci/archive/20261020/202610200336.6v4SE96n-lkp@intel.com/config)
> compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
> rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610200336.6v4SE96n-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610200336.6v4SE96n-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> scripts/kallsyms.c:371:26: warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]  
>      371 |                         printf("\n\t.short\t" + !i);
>          |                                ~~~~~~~~~~~~~~~^~~~
>    scripts/kallsyms.c:371:26: note: use array indexing to silence this warning

Hmmm it gives the same error for (!i + "string") even though that doesn't even look
like a broken attempt to append to the string.


>      371 |                         printf("\n\t.short\t" + !i);
>          |                                               ^   
>          |                                &              [   ]
> >> scripts/kallsyms.c:371:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]  
>      371 |                         printf("\n\t.short\t" + !i);
>          |                                ^~~~~~~~~~~~~~~~~~~

The compiler ought to do better there...
Indeed, gcc does.

...
>    366		output_label("kallsyms_token_index");
>    367		for (i = 0; i < 256; i++) {
>    368			if (i & 15)
>    369				printf(",");
>    370			else
>  > 371				printf("\n\t.short\t" + !i);  
>    372			printf("%u", best_idx[i]);
>    373		}

I knew I should have interleaved putchar() and fputs() with the printf().
They are somewhat faster - in this file it is measurable.
gcc does convert printf() to putchar() or puts() but not fputs().

The time taken to write the files halves if I initialise an array with all the
",%u" values and use fputs(str[byte_val] + !comma).
I decided someone would object to the mess.

I'll think of something for v3.

David


