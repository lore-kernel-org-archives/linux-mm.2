Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC0C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB718E0067; Mon, 11 Aug 2025 10:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABF38E0065; Mon, 11 Aug 2025 10:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2338E0067; Mon, 11 Aug 2025 10:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B44048E0065
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:49:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40580B7361
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:49:34 +0000 (UTC)
X-FDA: 83764760268.08.A8F6E74
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1927F40013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:49:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fFsSvodw;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754923772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlFzUxPWHjx5grAM+2JEnhzKMq/lcSztmTKoL3AWCPo=;
	b=vNF7b13zJhbpBq24s6dfxxq6iUqIxlUzVnm9xag+NRU6X0etLUUawI73ri82w8LkL5OCZX
	1r/UgzeGzzTbmLU8kb81JWE6S2HiCoT3d/zIAjAdNT0JQyWYys+9IcewQke0aF71YkdrTz
	cKBLuhjV8pCwz1/b8KdyYXXFwmHYDZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754923772; a=rsa-sha256;
	cv=none;
	b=WZGXLPW4wy5Cdc8YoTgbayWDaGjRYO7SjX2Ar7lmSt5S5HtheO1iq8/MoPuooTRPqUaoUC
	MduHwybMpHYLOOelgzUGlW/qq3AAP33R//frFQ1694DJN53RateH7lb/B6Zrkqo/ZNJ8YM
	syMyEV9JMc9YAPdkEWKsIMfLDi89gZ0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=fFsSvodw;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qlFzUxPWHjx5grAM+2JEnhzKMq/lcSztmTKoL3AWCPo=; b=fFsSvodway9dLw4r27bUqyziiM
	ZFFt0NVoqQRzfTiHDy9Nv5/CwKTYc3aJHBm1s0dLRGK80/rCteCvbAsljVEr50AWbO92XvTLeHgUq
	I+lgvtPAFEQdyxe4y1n98IaxIJeK+OXEAWVfkS8Ek+4RVAyGD3es2IudckEa8WP12PhNoWl8YDtFh
	tvuyjWNdYOXZhMucOwRfdnFwbgBeq1D7Hv5y7InFFx9VAPz7KUUaOyxB17HKkzTjTsm2gq8a49tia
	B2yF+r+kJB/EShwuNwTdDMFcdEVuhq+7ZoaZmXpHNAaBm14PyLNV+5VcwfTNTyz/YtySAcdF6/1iF
	XQ6F59bg==;
Received: from [223.233.72.183] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1ulTpt-00CpHZ-13; Mon, 11 Aug 2025 16:49:17 +0200
Message-ID: <6b5c92c4-2170-8ce9-3c9f-45c0e1893e03@igalia.com>
Date: Mon, 11 Aug 2025 20:19:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, Bhupesh <bhupesh@igalia.com>,
 akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, laoar.shao@gmail.com,
 pmladek@suse.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
 arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl, peterz@infradead.org,
 willy@infradead.org, david@redhat.com, viro@zeniv.linux.org.uk,
 keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
 jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
 mgorman@suse.de
References: <20250811064609.918593-4-bhupesh@igalia.com>
 <202508111835.JFL8DgKY-lkp@intel.com>
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <202508111835.JFL8DgKY-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8m3t5gbeweud7s8otwxr3s8h3amf158x
X-Rspamd-Queue-Id: 1927F40013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754923771-160878
X-HE-Meta: U2FsdGVkX19ZoyAsh58h0okyAAJlKJSB7zEkU93vMS1feddYbIA+YwUP8oOuhNWRITZXtZ2nsIhgK7dVRmGcraQ0QeBL3SLu20BHqQNC0GIQhWjHP9DFE/K2ZGRND5UBGac4B1y+9HYEh0tTs/voJtWYAYVmrBSCOcqKkxGdx8gezGlm15P+GVpBZx+Q89rCA9ZHUwnjQvG0Y5IR6OI3M1l7ymUfA994+CBMe4p49I0pWxsVxNQVBKp22WqPMOERNOO/qldli4++GxML0juW0aVuwZrqKnkswh+zwL5NNL5oJ8bm3TDyL66EGCwp7q3C1oQGFYApg5xyOe/EK1rR1a5dKdvEe/CkVnbtJuAjPyc1nm0W/nxam23HXyvwq+xfMh5G14xsqFkp7SoMlfS9arCYRsGI0Cq64qQy8sUD20nmdFQdSmSNOBtmVHwD/U+u0kmvB31R25oDIjXrgs9h4ox9En6eK+1XjwM/rjpmzSFqokB0shuhvXlItmpCrozDml7TeYPOmPt3TuIaqIWIrOGoB6JXmgL8sx4Uj1jVtkj+Bosk/kF75eJwHd6JeI7JCy8aFL5g0grWYDvZ/ArPh8zuDjc/twJy1j8QdAPDyFt5TIz0ky+FoapB0IqiKzVp6o+C4mWVr02QARtx4c31BP/Xzm1LhFP8+UniWMlw57zGk1OxeZ9Z4h8cfelktM43/wIdqSlUOfBIlLdYIBgu165pYJt1qymy2HEnJq40m71K9KsDGSE3yXvf6dvOTBcTK7nTkk7KOULStUfRe7luqBlFcEBVEQqI1hSreaghv6a3tSz3PLCg2znsrsVwJxfxePw3FJs56CPOsWhMkur2gTaKH2dwMD1zURhO+aqeNvbAe7dsygitcrsG/4OXr6IFEpl7AnILBOoOdwB93F2y0ybWhcR25KVD/S0htPu9MXAX+HnJOwTmCJBVCqIOe7i5DeUzYnq/v9PaAyobTFo
 xLzDU2Nd
 fr+C+Xd9FRN4kONIa3hexADGiYhe5aWKnBUD6SIxAvdUpW6ATnhcmttIhlBNvBF9Ab6hatHbZcLwEQLae/dy91ZW2/oDQ1f/I5dmUEiPH9plJos9xYikNtrsU2+7DReu4eKv0NqICcCdS86gK2VqrF7t8zl6Vt95XFyRaOGxLj3jXdfYJBhHIhbViMCAOIMh6xyGIdy6+0nGsbscIuOIevY2sRBdigtjMuSTXkkT7tt5UTMf6UU1SqyLKuo66mM3DD018KdGhGnBA95hvJ6/mkDSAsTP4tJ+rNHq4Z0qw5g4bWGOESa75vdMwOJwJg/5vadIPaqHpAyc5TtF4IY+oiE7vgO7rQZQDLVJju/yHVo1uXNx2iQVNT+tTX5tZXVynGARxBrpnAxSfOtNopW2I9Cz5OJCRLYjLNxmOp0HrROizjQKJ/+rxd1fEFkAzmdBQ5Bb6jcVpwGZ9oenkmSQGO8u9si4L0KqvO8jCYDbH2uFOJiA/1nRvNo9gwfQTl1F1uPHD52bXArWsznHUvntY8GKKSn1dR1dbiorbejBssJEWNuBYhZawPuhZnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/11/25 4:55 PM, kernel test robot wrote:
> Hi Bhupesh,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on next-20250808]
> [cannot apply to trace/for-next tip/sched/core brauner-vfs/vfs.all linus/master v6.17-rc1 v6.16 v6.16-rc7 v6.17-rc1]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250811-144920
> base:   next-20250808
> patch link:    https://lore.kernel.org/r/20250811064609.918593-4-bhupesh%40igalia.com
> patch subject: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
> config: sh-randconfig-002-20250811 (https://download.01.org/0day-ci/archive/20250811/202508111835.JFL8DgKY-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250811/202508111835.JFL8DgKY-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508111835.JFL8DgKY-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>     In file included from include/linux/bitmap.h:13,
>                      from include/linux/cpumask.h:12,
>                      from include/linux/smp.h:13,
>                      from include/linux/lockdep.h:14,
>                      from include/linux/spinlock.h:63,
>                      from include/linux/mmzone.h:8,
>                      from include/linux/gfp.h:7,
>                      from include/linux/umh.h:4,
>                      from include/linux/kmod.h:9,
>                      from include/linux/module.h:18,
>                      from net/netfilter/nf_tables_api.c:8:
>     net/netfilter/nf_tables_api.c: In function 'nf_tables_fill_gen_info':
>>> include/linux/string.h:116:50: error: passing argument 3 of 'nla_put_string' makes pointer from integer without a cast [-Wint-conversion]
>       116 | #define sized_strscpy_pad(dest, src, count)     ({                      \
>           |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~
>           |                                                  |
>           |                                                  ssize_t {aka int}
>       117 |         char *__dst = (dest);                                           \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       118 |         const char *__src = (src);                                      \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       119 |         const size_t __count = (count);                                 \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       120 |         ssize_t __wrote;                                                \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       121 |                                                                         \
>           |                                                                         ~
>       122 |         __wrote = sized_strscpy(__dst, __src, __count);                 \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       123 |         if (__wrote >= 0 && __wrote < __count)                          \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       124 |                 memset(__dst + __wrote + 1, 0, __count - __wrote - 1);  \
>           |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       125 |         __wrote;                                                        \
>           |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       126 | })
>           | ~~
>     include/linux/string.h:86:9: note: in expansion of macro 'sized_strscpy_pad'
>        86 |         sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +        \
>           |         ^~~~~~~~~~~~~~~~~
>     include/linux/args.h:25:24: note: in expansion of macro '__strscpy_pad0'
>        25 | #define __CONCAT(a, b) a ## b
>           |                        ^
>     include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
>        26 | #define CONCATENATE(a, b) __CONCAT(a, b)
>           |                           ^~~~~~~~
>     include/linux/string.h:149:9: note: in expansion of macro 'CONCATENATE'
>       149 |         CONCATENATE(__strscpy_pad, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
>           |         ^~~~~~~~~~~
>     net/netfilter/nf_tables_api.c:9661:53: note: in expansion of macro 'strscpy_pad'
>      9661 |             nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
>           |                                                     ^~~~~~~~~~~
>     In file included from include/linux/netfilter/nfnetlink.h:7,
>                      from net/netfilter/nf_tables_api.c:17:
>     include/net/netlink.h:1655:46: note: expected 'const char *' but argument is of type 'ssize_t' {aka 'int'}
>      1655 |                                  const char *str)
>           |                                  ~~~~~~~~~~~~^~~
>
>
> vim +/nla_put_string +116 include/linux/string.h
>
> e6584c3964f2ff Kees Cook        2023-09-20   74
> e6584c3964f2ff Kees Cook        2023-09-20   75  /*
> e6584c3964f2ff Kees Cook        2023-09-20   76   * The 2 argument style can only be used when dst is an array with a
> e6584c3964f2ff Kees Cook        2023-09-20   77   * known size.
> e6584c3964f2ff Kees Cook        2023-09-20   78   */
> e6584c3964f2ff Kees Cook        2023-09-20   79  #define __strscpy0(dst, src, ...)	\
> 559048d156ff33 Kees Cook        2024-08-05   80  	sized_strscpy(dst, src, sizeof(dst) + __must_be_array(dst) +	\
> 559048d156ff33 Kees Cook        2024-08-05   81  				__must_be_cstr(dst) + __must_be_cstr(src))
> 559048d156ff33 Kees Cook        2024-08-05   82  #define __strscpy1(dst, src, size)	\
> 559048d156ff33 Kees Cook        2024-08-05   83  	sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
> e6584c3964f2ff Kees Cook        2023-09-20   84
> 8366d124ec937c Kees Cook        2024-02-02   85  #define __strscpy_pad0(dst, src, ...)	\
> 559048d156ff33 Kees Cook        2024-08-05   86  	sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +	\
> 559048d156ff33 Kees Cook        2024-08-05   87  				    __must_be_cstr(dst) + __must_be_cstr(src))
> 559048d156ff33 Kees Cook        2024-08-05   88  #define __strscpy_pad1(dst, src, size)	\
> 559048d156ff33 Kees Cook        2024-08-05   89  	sized_strscpy_pad(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
> 458a3bf82df4fe Tobin C. Harding 2019-04-05   90
> e6584c3964f2ff Kees Cook        2023-09-20   91  /**
> e6584c3964f2ff Kees Cook        2023-09-20   92   * strscpy - Copy a C-string into a sized buffer
> e6584c3964f2ff Kees Cook        2023-09-20   93   * @dst: Where to copy the string to
> e6584c3964f2ff Kees Cook        2023-09-20   94   * @src: Where to copy the string from
> e6584c3964f2ff Kees Cook        2023-09-20   95   * @...: Size of destination buffer (optional)
> e6584c3964f2ff Kees Cook        2023-09-20   96   *
> e6584c3964f2ff Kees Cook        2023-09-20   97   * Copy the source string @src, or as much of it as fits, into the
> e6584c3964f2ff Kees Cook        2023-09-20   98   * destination @dst buffer. The behavior is undefined if the string
> e6584c3964f2ff Kees Cook        2023-09-20   99   * buffers overlap. The destination @dst buffer is always NUL terminated,
> e6584c3964f2ff Kees Cook        2023-09-20  100   * unless it's zero-sized.
> e6584c3964f2ff Kees Cook        2023-09-20  101   *
> e6584c3964f2ff Kees Cook        2023-09-20  102   * The size argument @... is only required when @dst is not an array, or
> e6584c3964f2ff Kees Cook        2023-09-20  103   * when the copy needs to be smaller than sizeof(@dst).
> e6584c3964f2ff Kees Cook        2023-09-20  104   *
> e6584c3964f2ff Kees Cook        2023-09-20  105   * Preferred to strncpy() since it always returns a valid string, and
> e6584c3964f2ff Kees Cook        2023-09-20  106   * doesn't unnecessarily force the tail of the destination buffer to be
> e6584c3964f2ff Kees Cook        2023-09-20  107   * zero padded. If padding is desired please use strscpy_pad().
> e6584c3964f2ff Kees Cook        2023-09-20  108   *
> e6584c3964f2ff Kees Cook        2023-09-20  109   * Returns the number of characters copied in @dst (not including the
> e6584c3964f2ff Kees Cook        2023-09-20  110   * trailing %NUL) or -E2BIG if @size is 0 or the copy from @src was
> e6584c3964f2ff Kees Cook        2023-09-20  111   * truncated.
> e6584c3964f2ff Kees Cook        2023-09-20  112   */
> e6584c3964f2ff Kees Cook        2023-09-20  113  #define strscpy(dst, src, ...)	\
> e6584c3964f2ff Kees Cook        2023-09-20  114  	CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
> 458a3bf82df4fe Tobin C. Harding 2019-04-05  115
> 8366d124ec937c Kees Cook        2024-02-02 @116  #define sized_strscpy_pad(dest, src, count)	({			\
> 8366d124ec937c Kees Cook        2024-02-02  117  	char *__dst = (dest);						\
> 8366d124ec937c Kees Cook        2024-02-02  118  	const char *__src = (src);					\
> 8366d124ec937c Kees Cook        2024-02-02  119  	const size_t __count = (count);					\
> 8366d124ec937c Kees Cook        2024-02-02  120  	ssize_t __wrote;						\
> 8366d124ec937c Kees Cook        2024-02-02  121  									\
> 8366d124ec937c Kees Cook        2024-02-02  122  	__wrote = sized_strscpy(__dst, __src, __count);			\
> 8366d124ec937c Kees Cook        2024-02-02  123  	if (__wrote >= 0 && __wrote < __count)				\
> 8366d124ec937c Kees Cook        2024-02-02  124  		memset(__dst + __wrote + 1, 0, __count - __wrote - 1);	\
> 8366d124ec937c Kees Cook        2024-02-02  125  	__wrote;							\
> 8366d124ec937c Kees Cook        2024-02-02  126  })
> 8366d124ec937c Kees Cook        2024-02-02  127
>

As mentioned in the accompanying cover letter, this patchset is based on 
'linux-next/master' (the exact sha-id used for rebase is: 
b1549501188cc9eba732c25b033df7a53ccc341f ).

Thanks,
Bhupesh

