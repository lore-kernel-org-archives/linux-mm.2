Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435C2CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 03:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75598E00A9; Mon, 11 Aug 2025 23:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D528E0045; Mon, 11 Aug 2025 23:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BA88E00A9; Mon, 11 Aug 2025 23:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81CF38E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:48:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08936C0141
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:48:07 +0000 (UTC)
X-FDA: 83766722214.19.F6CF827
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49C734000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:48:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqQNoNc0;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754970485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tr52eI2LFZAQvtCKmuN+kO7LcKH0pTPx/ZlLmifWHPI=;
	b=y1J7VxkVFi9TehYN6TaAPBhdaBY8Qqq5rrLHdQyaFArNtRS0AuuN15f/JvNmErjwLI1xTz
	kJQ+b+3p4S2l2rVRgHvBANVF8Vl9udHJ1psq7OjlH49ZMj0Dg1HJ2h9PG0hQXgG5ciRk11
	aHCFfcLkDhNz/J5b6I3ud6zmSN54I8k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kqQNoNc0;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754970485; a=rsa-sha256;
	cv=none;
	b=zI841pnacDCB77FhmAvWD1bvQ1Sqc2NyRPiPecM+Ov2sGEi4DZKx82k1MyXa0JQCVHuPNH
	cHTC1ZWX5n8ANrdxRg0mae2om7FG+NcwoFDKnH6Bh+fKzsaQgN2iw0Yj5UN0CeSIlqVNC8
	gr1xyzM6TkTuchujpDTpz/jwl/mLGe4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754970485; x=1786506485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ll3cdP8d//vor5VuPJwHFE7JYGIjaL7Gs2uj46+wuYE=;
  b=kqQNoNc0rxPaY8JSoK++uAX3VLHJwh4csFES+EQ44m5NB49xmcyALA8Y
   56OwA/ef9xqdpGDF16WZsbFXyFRoftmZatcYLAdhJF02QpKbLeEuz8kGg
   1NA+u7iows05nW4WKz6ik4JMpPCLtwpsbHApSt3x5V5K7TUi2BS6bkjx0
   C4qrJ9a5HQhSb+JsADzxa1jktUsj6KNMuOgAoIHjRTd66I99dmtYQf5RF
   YwqClzZ8JLL3GFGToIDibXzLSRGN6rCviEvTvK0Xx48drjcLSUIJ0myc3
   V0xueAPfA4yIKUvfxdRmoAZwyyxa8SbAysbIektSosfFsrB44l4QwTV6X
   w==;
X-CSE-ConnectionGUID: k3ke/eiTQ7qqjiM0F3y72w==
X-CSE-MsgGUID: TvgfVxArTZWTtulFFMFdcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79805652"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="79805652"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 20:48:03 -0700
X-CSE-ConnectionGUID: rBXqWIpGTrGEXfd288J8uw==
X-CSE-MsgGUID: h6B2w0GfRnCeW4xa5h7SyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="196928492"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 11 Aug 2025 20:47:56 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ulfzN-0006Oa-0z;
	Tue, 12 Aug 2025 03:47:53 +0000
Date: Tue, 12 Aug 2025 11:47:52 +0800
From: kernel test robot <lkp@intel.com>
To: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, bhupesh@igalia.com,
	kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	oliver.sang@intel.com, lkp@intel.com, laoar.shao@gmail.com,
	pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Message-ID: <202508121145.d07aFegg-lkp@intel.com>
References: <20250811064609.918593-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-4-bhupesh@igalia.com>
X-Stat-Signature: djo79731gof7afxzg8egd7kp58z86m8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 49C734000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1754970484-595157
X-HE-Meta: U2FsdGVkX1/yqCe/H11cQRnutFNywrd7H3nY1hKOuMFBV6NiKOmKh6JZdJB3Qx9+OTQ8+ywSlX9b+sGIy05MCnoBT23ghlf9PhXIXhz+IrXQXV/1Zl3SmG0pXOdol00GGqQngv3v6ueSP4olivJ4fg6GXFdzHpejeW4M3OdeAoYgItEW+4ZZwDxxRuxCMdy84vKG0065Q5QRxbyJGtGFv0ex5kSXNy18+tmx3eIs32FJS+UR61jVIHrEWMmgqyMSTKAY+55ZrAOEm86fH0h+rZ55LMlADxB7uUm/8PWOrIV0PyErDx8IsWxj4ZP8GGaX798iLmpRGo3vKQT52Fy80iBLmLTtK2lfqxhUtdOBWzAe3t0hY28K8ebFoFAvZlBb7arbt3k5ntzZAKKCVPjlm2vEdbh++VSKlD/wsf8FvKoYIXA4RvG4+x/bWmT6NoP2HCYt84rNspJGAZ9HjOGRQEyrhuoALN/avvQf7UAV9iSkgV9T0CJ/c5Uv9hkaTKXNNR1IsQj9J3it0KwQIMqkK0fZcfOZaatQHPplIhQv+jQuNXhXPzRQtK9gg615xfWIFQ7HW6uDXqILx0mgNItU5sMj3KXADZWke0MFmxBCWl8zGx1FpxeTTKa/1dCGtDHdDsxSbywTPyJY7Hx8dTIE94AoV6eus+acVvwyeb0S1wGFMtRw5kzQbvtEtrMKWS2hvPs9fOg/MpTVHd7tlNXoEcbBHmamPC7byQFxb7Bp9j8Zf+GeYSvH5jswkXJ2a7VycxicIUv+tCmdhWdyZSA6gqZcerxtLwU+/2WeHJ9+FS+OcdwOBYA7RP4OdE+MUmejoLg+Zp8guOwd6VFkehBTTxWwkg1tyveN3Jted9MLV5Inb09BrCW7Et6eVPcLZFEToSlllM5SNZW+rOOGp2DLc7IrWHSn28TMFC27WJ4UFhul8nEOq2ONRkHfeTvhSaM3X7p4yxhdRAy2QW8Vts0
 ExVFeWZL
 ei+zlcAGHD8jykowuialNU1yDZNSiYOuGehem/L/2VGV68R8VdUPDZlsarzCo7damPttjlavJtGrGjGFl95WUaZpak2WoTOBfRj8UL+heQqC4pJLFngkmY4pC+0jZ/AbhR8gDIISj8WOP+Da0Dd19N+znxzR/9ayGNYVK56zesakGuQtEAayIBpOXgA6vQ5WesgTZYNF8fUN8dBldmF4ZUMKlaJ2k9GsE0ccgVXTYcIOjXSUmrc1P2bh+YvgZMQHps7Ex/7Sk8t9/M9Qtzo9vqp/E9LAQbcjvUhn16Xf+TG2IfH9uhD5kOwi+WsQbxhMprS0qWVXVDTgbgOpHwcK/gYAh8yZVJM8JRt9aOcD/ydoNTDYXWV8KSRGzXRtxNhZP02u9cD0hquPbzmdU51SG6E0VEU0ctnVEk6CVMHydISxre3NTWEdCwo+A3zSdrJy+oBvXHRv0wfUZd8iXJRa6nmy7i8IKARfvZsyaDJxF4vYy14QXdLBDgEcmvV6PVmLFjPvaccxOEbArJk9MFHESRrnbsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bhupesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20250808]
[cannot apply to trace/for-next tip/sched/core brauner-vfs/vfs.all linus/master v6.17-rc1 v6.16 v6.16-rc7 v6.17-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250811-144920
base:   next-20250808
patch link:    https://lore.kernel.org/r/20250811064609.918593-4-bhupesh%40igalia.com
patch subject: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
config: arc-randconfig-002-20250812 (https://download.01.org/0day-ci/archive/20250812/202508121145.d07aFegg-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250812/202508121145.d07aFegg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508121145.d07aFegg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
   net/netfilter/nf_tables_api.c: In function 'nf_tables_fill_gen_info':
>> include/linux/string.h:116:50: warning: passing argument 3 of 'nla_put_string' makes pointer from integer without a cast [-Wint-conversion]
     116 | #define sized_strscpy_pad(dest, src, count)     ({                      \
         |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                  |
         |                                                  ssize_t {aka int}
     117 |         char *__dst = (dest);                                           \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     118 |         const char *__src = (src);                                      \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     119 |         const size_t __count = (count);                                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     120 |         ssize_t __wrote;                                                \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     121 |                                                                         \
         |                                                                         ~
     122 |         __wrote = sized_strscpy(__dst, __src, __count);                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     123 |         if (__wrote >= 0 && __wrote < __count)                          \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     124 |                 memset(__dst + __wrote + 1, 0, __count - __wrote - 1);  \
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     125 |         __wrote;                                                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     126 | })
         | ~~                                                
   include/linux/compiler.h:57:52: note: in definition of macro '__trace_if_var'
      57 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                    ^~~~
   net/netfilter/nf_tables_api.c:9659:9: note: in expansion of macro 'if'
    9659 |         if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_net->base_seq)) ||
         |         ^~
   include/linux/string.h:86:9: note: in expansion of macro 'sized_strscpy_pad'
      86 |         sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +        \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy_pad0'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:149:9: note: in expansion of macro 'CONCATENATE'
     149 |         CONCATENATE(__strscpy_pad, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   net/netfilter/nf_tables_api.c:9661:53: note: in expansion of macro 'strscpy_pad'
    9661 |             nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
         |                                                     ^~~~~~~~~~~
   In file included from include/linux/netfilter/nfnetlink.h:7,
                    from net/netfilter/nf_tables_api.c:17:
   include/net/netlink.h:1655:46: note: expected 'const char *' but argument is of type 'ssize_t' {aka 'int'}
    1655 |                                  const char *str)
         |                                  ~~~~~~~~~~~~^~~
>> include/linux/string.h:116:50: warning: passing argument 3 of 'nla_put_string' makes pointer from integer without a cast [-Wint-conversion]
     116 | #define sized_strscpy_pad(dest, src, count)     ({                      \
         |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                  |
         |                                                  ssize_t {aka int}
     117 |         char *__dst = (dest);                                           \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     118 |         const char *__src = (src);                                      \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     119 |         const size_t __count = (count);                                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     120 |         ssize_t __wrote;                                                \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     121 |                                                                         \
         |                                                                         ~
     122 |         __wrote = sized_strscpy(__dst, __src, __count);                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     123 |         if (__wrote >= 0 && __wrote < __count)                          \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     124 |                 memset(__dst + __wrote + 1, 0, __count - __wrote - 1);  \
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     125 |         __wrote;                                                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     126 | })
         | ~~                                                
   include/linux/compiler.h:57:61: note: in definition of macro '__trace_if_var'
      57 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                             ^~~~
   net/netfilter/nf_tables_api.c:9659:9: note: in expansion of macro 'if'
    9659 |         if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_net->base_seq)) ||
         |         ^~
   include/linux/string.h:86:9: note: in expansion of macro 'sized_strscpy_pad'
      86 |         sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +        \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy_pad0'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:149:9: note: in expansion of macro 'CONCATENATE'
     149 |         CONCATENATE(__strscpy_pad, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   net/netfilter/nf_tables_api.c:9661:53: note: in expansion of macro 'strscpy_pad'
    9661 |             nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
         |                                                     ^~~~~~~~~~~
   include/net/netlink.h:1655:46: note: expected 'const char *' but argument is of type 'ssize_t' {aka 'int'}
    1655 |                                  const char *str)
         |                                  ~~~~~~~~~~~~^~~
>> include/linux/string.h:116:50: warning: passing argument 3 of 'nla_put_string' makes pointer from integer without a cast [-Wint-conversion]
     116 | #define sized_strscpy_pad(dest, src, count)     ({                      \
         |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                  |
         |                                                  ssize_t {aka int}
     117 |         char *__dst = (dest);                                           \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     118 |         const char *__src = (src);                                      \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     119 |         const size_t __count = (count);                                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     120 |         ssize_t __wrote;                                                \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     121 |                                                                         \
         |                                                                         ~
     122 |         __wrote = sized_strscpy(__dst, __src, __count);                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     123 |         if (__wrote >= 0 && __wrote < __count)                          \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     124 |                 memset(__dst + __wrote + 1, 0, __count - __wrote - 1);  \
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     125 |         __wrote;                                                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     126 | })
         | ~~                                                
   include/linux/compiler.h:68:10: note: in definition of macro '__trace_if_value'
      68 |         (cond) ?                                        \
         |          ^~~~
   include/linux/compiler.h:55:28: note: in expansion of macro '__trace_if_var'
      55 | #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
         |                            ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:9659:9: note: in expansion of macro 'if'
    9659 |         if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_net->base_seq)) ||
         |         ^~
   include/linux/string.h:86:9: note: in expansion of macro 'sized_strscpy_pad'
      86 |         sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +        \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy_pad0'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:149:9: note: in expansion of macro 'CONCATENATE'
     149 |         CONCATENATE(__strscpy_pad, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   net/netfilter/nf_tables_api.c:9661:53: note: in expansion of macro 'strscpy_pad'
    9661 |             nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
         |                                                     ^~~~~~~~~~~
   include/net/netlink.h:1655:46: note: expected 'const char *' but argument is of type 'ssize_t' {aka 'int'}
    1655 |                                  const char *str)
         |                                  ~~~~~~~~~~~~^~~


vim +/nla_put_string +116 include/linux/string.h

e6584c3964f2ff Kees Cook        2023-09-20   74  
e6584c3964f2ff Kees Cook        2023-09-20   75  /*
e6584c3964f2ff Kees Cook        2023-09-20   76   * The 2 argument style can only be used when dst is an array with a
e6584c3964f2ff Kees Cook        2023-09-20   77   * known size.
e6584c3964f2ff Kees Cook        2023-09-20   78   */
e6584c3964f2ff Kees Cook        2023-09-20   79  #define __strscpy0(dst, src, ...)	\
559048d156ff33 Kees Cook        2024-08-05   80  	sized_strscpy(dst, src, sizeof(dst) + __must_be_array(dst) +	\
559048d156ff33 Kees Cook        2024-08-05   81  				__must_be_cstr(dst) + __must_be_cstr(src))
559048d156ff33 Kees Cook        2024-08-05   82  #define __strscpy1(dst, src, size)	\
559048d156ff33 Kees Cook        2024-08-05   83  	sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
e6584c3964f2ff Kees Cook        2023-09-20   84  
8366d124ec937c Kees Cook        2024-02-02   85  #define __strscpy_pad0(dst, src, ...)	\
559048d156ff33 Kees Cook        2024-08-05   86  	sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +	\
559048d156ff33 Kees Cook        2024-08-05   87  				    __must_be_cstr(dst) + __must_be_cstr(src))
559048d156ff33 Kees Cook        2024-08-05   88  #define __strscpy_pad1(dst, src, size)	\
559048d156ff33 Kees Cook        2024-08-05   89  	sized_strscpy_pad(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
458a3bf82df4fe Tobin C. Harding 2019-04-05   90  
e6584c3964f2ff Kees Cook        2023-09-20   91  /**
e6584c3964f2ff Kees Cook        2023-09-20   92   * strscpy - Copy a C-string into a sized buffer
e6584c3964f2ff Kees Cook        2023-09-20   93   * @dst: Where to copy the string to
e6584c3964f2ff Kees Cook        2023-09-20   94   * @src: Where to copy the string from
e6584c3964f2ff Kees Cook        2023-09-20   95   * @...: Size of destination buffer (optional)
e6584c3964f2ff Kees Cook        2023-09-20   96   *
e6584c3964f2ff Kees Cook        2023-09-20   97   * Copy the source string @src, or as much of it as fits, into the
e6584c3964f2ff Kees Cook        2023-09-20   98   * destination @dst buffer. The behavior is undefined if the string
e6584c3964f2ff Kees Cook        2023-09-20   99   * buffers overlap. The destination @dst buffer is always NUL terminated,
e6584c3964f2ff Kees Cook        2023-09-20  100   * unless it's zero-sized.
e6584c3964f2ff Kees Cook        2023-09-20  101   *
e6584c3964f2ff Kees Cook        2023-09-20  102   * The size argument @... is only required when @dst is not an array, or
e6584c3964f2ff Kees Cook        2023-09-20  103   * when the copy needs to be smaller than sizeof(@dst).
e6584c3964f2ff Kees Cook        2023-09-20  104   *
e6584c3964f2ff Kees Cook        2023-09-20  105   * Preferred to strncpy() since it always returns a valid string, and
e6584c3964f2ff Kees Cook        2023-09-20  106   * doesn't unnecessarily force the tail of the destination buffer to be
e6584c3964f2ff Kees Cook        2023-09-20  107   * zero padded. If padding is desired please use strscpy_pad().
e6584c3964f2ff Kees Cook        2023-09-20  108   *
e6584c3964f2ff Kees Cook        2023-09-20  109   * Returns the number of characters copied in @dst (not including the
e6584c3964f2ff Kees Cook        2023-09-20  110   * trailing %NUL) or -E2BIG if @size is 0 or the copy from @src was
e6584c3964f2ff Kees Cook        2023-09-20  111   * truncated.
e6584c3964f2ff Kees Cook        2023-09-20  112   */
e6584c3964f2ff Kees Cook        2023-09-20  113  #define strscpy(dst, src, ...)	\
e6584c3964f2ff Kees Cook        2023-09-20  114  	CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
458a3bf82df4fe Tobin C. Harding 2019-04-05  115  
8366d124ec937c Kees Cook        2024-02-02 @116  #define sized_strscpy_pad(dest, src, count)	({			\
8366d124ec937c Kees Cook        2024-02-02  117  	char *__dst = (dest);						\
8366d124ec937c Kees Cook        2024-02-02  118  	const char *__src = (src);					\
8366d124ec937c Kees Cook        2024-02-02  119  	const size_t __count = (count);					\
8366d124ec937c Kees Cook        2024-02-02  120  	ssize_t __wrote;						\
8366d124ec937c Kees Cook        2024-02-02  121  									\
8366d124ec937c Kees Cook        2024-02-02  122  	__wrote = sized_strscpy(__dst, __src, __count);			\
8366d124ec937c Kees Cook        2024-02-02  123  	if (__wrote >= 0 && __wrote < __count)				\
8366d124ec937c Kees Cook        2024-02-02  124  		memset(__dst + __wrote + 1, 0, __count - __wrote - 1);	\
8366d124ec937c Kees Cook        2024-02-02  125  	__wrote;							\
8366d124ec937c Kees Cook        2024-02-02  126  })
8366d124ec937c Kees Cook        2024-02-02  127  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

