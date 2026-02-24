Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B33F4BB8B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 21:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474DF6B0089; Tue, 24 Feb 2026 16:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F376B008A; Tue, 24 Feb 2026 16:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FBF6B008C; Tue, 24 Feb 2026 16:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 214F26B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:15:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC543573DD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:15:14 +0000 (UTC)
X-FDA: 84480605748.14.92D751B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1B924000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:15:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YvhuG8NF;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771967712; a=rsa-sha256;
	cv=pass;
	b=VRtau5KUdsIKGZMOiwVpsVLoSqEQXQUHLr9TKF8f9izamR0wzhmTLNBaCGCVUc3JuhiS6Y
	TD3I/eAAW9JSERPURnLfxwCfeU1kXAbOJD5vuVH2S+/B0yv/wTyvgHQChxn4S8z6TqZji5
	taAa2tNy9+/5KIpWxFO2y1GMUhhFFas=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YvhuG8NF;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771967712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p/EscjPc4RwdFKAEV1F/Hcd5UZ99lvhttD+tVMi300=;
	b=P9P0284WtohY/mRmaNNG4ztL/uSaNhcUJej3TU8KjycYOoob3VYORESNHudUtJc4lVNTNZ
	wEQptgFTHcNHo0+/5q5VYuQ8cLHOwIHTTJKwzoaIWg20LGNHaSuPoa61/Forz+/u0RKlMp
	2uziVX4/m2ddryG49/HtrH6KdgsBKvA=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b64256dso135391cf.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:15:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771967712; cv=none;
        d=google.com; s=arc-20240605;
        b=RgXQMjxNUu/XNHk8P/uOHuZFpICo8+udRVf+ZB/cunXAnt4kmbhV9HHnosw9UdCKtk
         8qWjn+jMlpmKYMP42uc3uON5OpClEv2+F57lOyUjn/U2SEYyzq9DTWLS3/Ew43AHx1l4
         nGGUmEabzE/ZXKpyJrNJ5FOD5fxGwoxQZyyTSjJV4E5Wd5CzTv0ii+9TsjY+2g+9tqar
         XAWXn2yY4p0NoAffC+qLWcsZ5X1jZI33eC47AZmNXDSoe5gO57KENa/JI36YzOGgcJqj
         rm2hBd/1fNpdDdZMg8yatGiFXcy6a+dpyIcej73SAx1tO3kdi3t4k6OEQNgcKKygJ7Xt
         cA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6p/EscjPc4RwdFKAEV1F/Hcd5UZ99lvhttD+tVMi300=;
        fh=EuIjADNrKf0DJMXItXWgmLZG7j3QzCJ147Azcdaqa58=;
        b=F3vS2wMCF8lA5eMHUFe52UILdbrmAwiOGCluNQRLLKP9GZZqAm2alunuKJnZCrYkg0
         GDanOvuuTiRv8LUr5wIjBA4HNCDT1YknUyBOvwR48W4Xau4l1eziGTprvWAmgLgLtUlZ
         3mM2Lxu3w7tjKvUswv3idLvNwqf2nwDuNu/+civrGdgJcqJCQ1B7iZQNgorGe8+t0fJi
         Y+zNjX21kYnHLV1oA2Q5DqnuKDvDoNTnd9ZU4UbbY1VNXMENVYOKazEsCZ0yLvRbZ6p7
         4Hc+MTz/DIfCKzBC5mtPN+kCM+l/Ld28BlSgGclTrdtt1u6dGr/b3sFqHhK7y25TZON+
         5FRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771967712; x=1772572512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6p/EscjPc4RwdFKAEV1F/Hcd5UZ99lvhttD+tVMi300=;
        b=YvhuG8NFY85a+Prt5E0eB9GOEFHDdgk2S1Ur5V14pPgzi9IK8kHuHeNGbNKpvPhfOh
         3EKkID3QDPLsyP8JBPwMyFijAB+0rTlUE/odiGsB3q3BxSz8nEQjkdjTGLzGy+Qf7KSK
         2LTd/oDO+lF0ENsCXj2UkqkkmXxT9553L7E1sRVywgQ6U8i0AEqHN5o4Kn3V4sgToJlm
         +um+EvI3+faF2kSmnT2sx/q/X29p8eeNhu+RVQJOlAgft/A80UVMBlUh1SdbhX683p7V
         g90n6/J7P8ME57p6Nzvi3nI3YL1AblA35UhkTAQWn0NunRLQGSUy4lRW7braHgqIGQ2a
         oPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771967712; x=1772572512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6p/EscjPc4RwdFKAEV1F/Hcd5UZ99lvhttD+tVMi300=;
        b=H91qO0H+0ga0e6Z9Hbkob9nOKdkMYqYStsrVbZ93sacnGNLxEk/7CRT0cBPD4nFkFt
         1QsSUjkt8DqxYDckWcPaitxLRl2Y/4smCURBAGrve7kZz8m9f7563X19GRR66oNsx+GA
         PUQd68DbSpHxXf/+Q6wr2df3APl0WTQd0y0nSuhbYEwEHN+ONtrgCQS25X5JsJxYvBh1
         Q9ZFnOu5yEoV1+IaZJXGt0ygnzcAcP5dFaeSdyZ/txsNpyH56cy2q2rtbJ+Ses6DCNc6
         0j0SNX+zA0HqIraL6Cshr2zorng0+CnB8BcY0TCKOfkZ7y5nTEhxA/z/pyAZ6oxiLYvF
         CQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCWw0sfuf1d7KpgOnWw6PXIdrntNfvRyW4DTYy1Ji351vrz+DeXiREODPYc84LXd6mbYe8cFS3rzzQ==@kvack.org
X-Gm-Message-State: AOJu0Yyr4a07tbCRkStnYc03EF80lovkefYxKuZnPcGIgYSlIMFMtV6k
	0RlxDQjjlxAmzlqE2r6DSm21x6oyjOKngX4LPWCPelSqSu5oi6QUqf4Bbdw3KsrwJa6PIXeAve+
	Sua/d/MXLY2iSqYb5hmMa8A5Y/VEdqrEx8lR0VpUC
X-Gm-Gg: AZuq6aLBSdij+h8LRerG2dTsmI+Lj/uOgCSCukRZrVSxzydzCGHqQ7fLw/aC0U5tcCQ
	JiQIn5y3OqwMR89q+QppArtFArAN3VyZ02DauhEdIQfAjTJBsoTiU3eSBWgqx62aoK2Kf247g+L
	ACTQaSLwh55fcoD5OTkRsCe3UdLZBnD3kzN4aNk04ejITbmPT3llFb3c7v0Wy947NrYMGL0P2nO
	FcJ5M4MxfLiKN3QEeiJZ5z0CnEq/uUVj5uIGN/C7spC6/pStqJdhGVtNIiUqt/iIJqw/tJXXmbu
	egRRxbtktFOJg+JPKFNOJsbXp6AiuKNNSmLDc07/hy+y7vIT
X-Received: by 2002:ac8:7d41:0:b0:4ff:bf96:db86 with SMTP id
 d75a77b69052e-50739028793mr2962101cf.16.1771967711072; Tue, 24 Feb 2026
 13:15:11 -0800 (PST)
MIME-Version: 1.0
References: <20260224165250.1322946-1-surenb@google.com> <202602250250.n38q74JK-lkp@intel.com>
In-Reply-To: <202602250250.n38q74JK-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 13:14:59 -0800
X-Gm-Features: AaiRm51WuymRTNAhPkBO-yVwq4mhRHWTiS7MnS75L9UZH8fj6ktQ_w2NQi6eNiI
Message-ID: <CAJuCfpGcA7YmxzmJuEzjJyLAQrV-uGS1LH=B1eX50MSh09z21w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated
 with __GFP_NO_OBJ_EXT
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	00107082@163.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7pn6y71rq7pnwwnc8ghkjb7nytrf783w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1B924000D
X-HE-Tag: 1771967712-592098
X-HE-Meta: U2FsdGVkX1/UrMDQwBPjff6eNvFSknhIhM0Cpk0qGe35uIBDg0OiwsdHdDWt5Ci42awNnArefExvA1sJ0de1pGPjDeHgmVTGza5gNSqvDPv6LKvh8bNS7rAjXxz9Fs8fD3AZhmgTlXab4iEzR7/4EmHAUgXlK2uoyyeAgES6x0BQISup1Fc7az9Po8dY7lhSBT9E7n6f/Sz60MEtx4BBk61SuiT9292IGIZfxiRS6Wf74lx2uGHxZJheL73YYCMprCY9bNLpIpuF6bB655uzFBo7NwyRVbTOgsJJvSnbHKyFVr4e6rbxDTSZZ2CZWxpSvqSLzdJ5cH5VUhW3Fd93jodlxaFVfcztPEhLwjAgun2cBYPu3+R/jTCi0rBt4klVlxT6dHT+jM1Qs06VlhEqVv84iUzjKUWzSHQe3xSUP9k5Y8Pn9hEwCc8d5WNk/WUjCcw+fmGx1mKNyktSnXf+/Wasbw6nz79gmFdO83FfVhRuYgmkVRQWisFxWM1AdsGKobJNsloIa+PPZ+0DI5VHd2Bm+vkYVADIMjATB7yDgSueAr1xVDkaN/R3WF9X1xvFCoMkbtCCoxQXim8lt8iwQRbR8aSurXXoYgxnKzvbnaCLZYBKpKrY1kxiF5F5g2CvrcNTBO2UL4IF3NgW8EqB5SzPKUiqZ4J29bFx33247K0u+NMs+ot9n/r9xc4TxF+IFII0k8Ej82y0g1bmbHZkzRooiYI4OQ0sDYakGGKt3B4DPMNpVG2t0ElaHD9Zxp2Lwc6d2nRmU71wBhDAUyvWy6ixEWNgn8oY5BS637afuK1sSe+jL4Lq8nnP3pA7w8MFucPWtc1t2jpoE8s/ztdcCo9thlWTpFw+4AKKIPCFs/LGb43a3GYmD1qQ5qclaJxFJDToPwYdxGBSSXnCftQmfpQJmZgPpL+uglKc6XYQgNmfZHVrNpF0wf+3irMz8vOpMSkoJd6bMm/crzbR0OB
 VM/mdLYk
 vIsh/Ra/3zkvUO51kIpJS9BsxPKAcyulymOt0Yt7Zl7kcRdNrS0KZ4AxGSo6awAT5ERES4g+BfN4ed0cEsQgkLOTafrYI4RnQ3Mn91M0ysyu2UrsELOiQeNW9ZesX1nfrCXvbWJ4o7edLKrdlCiSf5oqkSBq4+2q0+XgnDHzOFYFb9KSSQw3Yn0Pmcej5J6pEg0jzd7mDbFOfkDQ+3q2LElR002oT+wTsPDfRnTxZL9Eb65DqOU1993WYGN1hsrvplICYrFwS7x3dALwW53n2+lnUz0wZsUn4A9wjols24Ar4rYqvpm5qUO8m+O//hmq9QJwC2vFGeUofwuZbzxTiqLMPdaujECi+zzWEGCCX8BKGagt4EV1TcQKeC4gv1k/D/bm98LGH3jgrSogRNsB6r+UErwvOMLZ6rgQladVhAfjUaWUfDgvZF4MD9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:54=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
>
> Hi Suren,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 7dff99b354601dd01829e1511711846e04340a69]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan=
/mm-slab-mark-alloc-tags-empty-for-sheafs-allocated-with-__GFP_NO_OBJ_EXT/2=
0260225-005422
> base:   7dff99b354601dd01829e1511711846e04340a69
> patch link:    https://lore.kernel.org/r/20260224165250.1322946-1-surenb%=
40google.com
> patch subject: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allo=
cated with __GFP_NO_OBJ_EXT
> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260=
225/202602250250.n38q74JK-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260225/202602250250.n38q74JK-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602250250.n38q74JK-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/slub.c:2787:3: error: call to undeclared function 'mark_objexts_emp=
ty'; ISO C99 and later do not support implicit function declarations [-Wimp=
licit-function-declaration]
>     2787 |                 mark_objexts_empty(sheaf);
>          |                 ^
>    1 error generated.

Thanks! In a hurry to post the fix I forgot to update the
mark_objexts_empty() definition for !CONFIG_MEM_ALLOC_PROFILING_DEBUG.
I'll post a fixed version shortly.

>
>
> vim +/mark_objexts_empty +2787 mm/slub.c
>
>   2783
>   2784  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sh=
eaf *sheaf)
>   2785  {
>   2786          if (s->flags & SLAB_KMALLOC)
> > 2787                  mark_objexts_empty(sheaf);
>   2788
>   2789          kfree(sheaf);
>   2790
>   2791          stat(s, SHEAF_FREE);
>   2792  }
>   2793
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

