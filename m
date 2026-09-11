Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E06DBC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 06:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0D66B0098; Fri, 11 Sep 2026 02:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8386B0099; Fri, 11 Sep 2026 02:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF0A6B009B; Fri, 11 Sep 2026 02:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA076B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:41:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3887D1C2AA2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:41:22 +0000 (UTC)
X-FDA: 85200534804.07.0E8B3B1
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C7AC40004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:41:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j8lhifba;
	spf=pass (imf12.hostedemail.com: domain of visitorckw@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789108880;
	b=m3j84AfADu+ME5x7A5/7UHyl+DuXd1K+mhsjkwSW/r96W9r053wxNyI/8LQs4YMILJ6dka
	aZ4ckrZ8EJ0CAqkacP92T2/lugXpLaym3vTwLupb9JpPeKPFwbd9kGNmc73RCUu+DlrSfs
	YgkkRKEC0ZhkMEE0jyY1opcHD9KIpEI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j8lhifba;
	spf=pass (imf12.hostedemail.com: domain of visitorckw@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789108880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqnrRH3JnuYg9d568dJH6IC4tGq2CueKpd9gXMr6rl0=;
	b=H1/hyicdRKzYvXPI+nSoayN55kAmHB8hxtr8XfnehRM2TqllNBtplNAdEDUfdHbcCqyTjk
	NbDdB+/sUZqVf5qa2JtD80NmvGV3dzDgxH4mazBvGCi66skVgyue7VX2Vkmb43OplMBLF5
	WDPdkAkkonkg7caMszdTVoFttx8hmcI=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86b90133ae8so157544b3a.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789108879; x=1789713679; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uqnrRH3JnuYg9d568dJH6IC4tGq2CueKpd9gXMr6rl0=;
        b=j8lhifbasfOdWyTCj3aDFD3SLur55TnWd7km3XQF/SZrMudm+zVvNIQyTBJLs8mW2H
         rTkgbTvjVdxogYdlnU72SC/ngTdaJJWWjuxKbQeap8L4gFlFwZ7mDmF17hnfSTen5CO1
         UgBXfS2xTx0Lw5k6x8zKe2gFfFMZzoeVV7uMcScK5wZDLiLbkNDgg+WGXGsVkMOmSEtq
         qfNlbTVeLBF1RcdldTlSBoUjYeegh19EkviTL9Mcj62d0w//0f0Jv30ZI+GwXRdeYSus
         SkO4I2yKonDTKPrJ+Ol7IQi3wwb/Pq5LwIaawgtt2RDhUEJmQJHIvPHeSrCWxoG0vGAU
         QnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789108879; x=1789713679;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqnrRH3JnuYg9d568dJH6IC4tGq2CueKpd9gXMr6rl0=;
        b=ARYW31JXrJzWtdhWyF86asxxyPRmRJTyPX+JA4/dvkBpgWkS/5XbTTouOTQTZftCU2
         pDZ9IKoomWqP6imTuqrvDFbpRSv5EkUnL3rwJJSX87KmQWD35GUIV4CkDjiHN+glXnoZ
         xRf8iSQflg50/zxbRi6jLWl9QoTzl9H53czuNzsD+YAKdy6Higxna7xwvhgdgNP/tVgN
         IVmiuO21vMWtyckiufACgEo2v3N6W+ecS7WjKUcAtdyumiehIoeKeHr9SMRzGUmUxcfy
         g36CXDQDXB0Rz76ZbfUsJ6iRFRXRcSeRrUJkOJssMagZUO07s2UUTeP4SmSVYZraGWWI
         WblA==
X-Forwarded-Encrypted: i=1; AKwUvBw1Y7MoqRYbWFAlLsTHXPrAKNAHmkaOPvGRIO1xLHTYj5a1OBQ+A0woBWxJXy/s/vKEfoUZaSs1jQ==@kvack.org
X-Gm-Message-State: AFuF++lW2AIycKgXcU6OmERkZQGqppRXN1LrKlOpcKciYGfagn6OXfjF
	QtehhyI8idKTJCnRBTG5NTGVVAdrBQnsKyMeiOi2wmN8R7ijEzPES6ey
X-Gm-Gg: AYBFou3PH29Hb9CZJDXLbAna2hlfW2zz9U3zMbEqjB1qQBdAK7daEQr6hhUsBZ+sLi5
	gZLrk4Mn2/RyWe9HQhP1PkX38hlZVfLA7Mo7JCh4YDEYgQGP7p0F+Xbmnlg0XoOSbb5E3L4nuF2
	N98tQZ6KOfYuoPrKNsakgwXOFCPQGwLwuI/FP2cs+KdszEwm174YZwvVuQA1dxl5NZ/nj0IG+yB
	E4T6WBHE2IzelqMW5Hp8yLip9Zmc+YrKqTpUjVzEkcuP47wX5MQQGSmtYuO2A+LmgOg74I5JUb+
	WbfvbcbsEVyYD8UQg8mhOsVK7J6a+N/0pzPSnAnACwQkNEKBwRgBrMVIwjVmug462BRYFqGf0wS
	oQCG14wnfPC9+UGpOn1AjkXo2+RHrtLGE6dsZbwUd4hBZBiUWODqp+RGChUvDT7Cm7J0Jc+Uckt
	ysJXTi1hnY6Pnr+BmF8n9fzI6b+FFeARUNQyKRoEwKFwAXbUYt2nDapP2PouQJ7D4UwDITpxm7W
	lFcozVrnXlXYmRluceEzdP9lS3sTDm6rQ==
X-Received: by 2002:a05:6a21:a95:b0:3da:6bdd:2c74 with SMTP id adf61e73a8af0-3daed306372mr6132777637.10.1789108878903;
        Thu, 10 Sep 2026 23:41:18 -0700 (PDT)
Received: from google.com ([2a00:79e0:2039:4:e7d0:6323:1ab1:99bf])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c615a84bsm674786a12.1.2026.09.10.23.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 23:41:18 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:41:14 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: lib/base64.c:58:18: warning: implicit conversion from 'int' to
 's8' (aka 'signed char') changes value from 131 to -125
Message-ID: <aqOiihm0Mz0zCnw0@google.com>
References: <202609110514.S0a0FD6a-lkp@intel.com>
 <20260910223520.GA3375179@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910223520.GA3375179@ax162>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C7AC40004
X-Stat-Signature: gmer7tgup4mjttiqm531nz36wwrh6qpp
X-HE-Tag: 1789108880-750482
X-HE-Meta: U2FsdGVkX19kgx8182YtVBQFm6wWpTTMRGPRbXitjq71AB5EC0ZNOthnE6n4+pcXsldQSFeuL2CHArE8MHEFBXPRpfw3QMbjS24avEhmgc69U+IiNGaQf4fvk/OMcGp3PyiZiKh+JrTsKumlu2Ol7CWktquT4PV2IqKhfvN4vRbTFzAr8kAqPrEHrphGfj3l0tLJv7U8Waivw1i4EY1IhSeY3VRRxUTKtKWnGHjEkVoircp1zl4JQ6kTs7+qtH1CwULj6WmFI9gXpkA6clpmhxKHTuuvfZMdkEV1rm8RxvyRBKy1c0YN4Mz7q2wjXnWSxArRhWt/3p8oLMPgo4n7fukR0rGqjdGtJHMtsGAaMBWLQ8+wUUNe5DoROpe56jjMT3pBt4ZTPKHi5jFbRNazY+twSjnlLtrg5Na9AocgEMWZgh++BY5GKdCzt3vcptIEX3WBtiMISL8dqS123wNyjCfds1LpkMse0+g5EEqvB5tVv8SBr7foPKA4AaSbfLwqnh29+arQ8M8rgt9f4x7KKMy5ZVthbozvVle5lOqRJsQEvJhy38aY0cEkswnZSOp0gMvVT8k+kN067sm7Jf/FRYfz6mWuQjau7oKtojdFYs2Ya9nnWLRgbnQqoNuKiHVzh1SLmOawo88iAQ5eQc2vGTYbyU1g1KmAD7sCPXfGvToVNWokcQoc5aR1o4qRZ7l3sqUv+5ZpsFaS8u3U40VL3bFi33xEaucyhODnm1Oqu5Qy0UVfvrG+cP5jGhZcEDjIW3fmmI1UAEjate76VaF4GQediyyI+i4beXLRqTGBhuKF2psWK9vrfDGaW4odB/kTsSVyoFgv+JI8RxjJu1htiDlKNInPRO2AZ+qsqBDni9F3MuirFcV5/ndynLcT7+6flTwGiKi39LlbCYTqX0gpOTRmxFlinHbglzedorr4NilHIkRrYDFz9vyo4P7xN1NL54jGvfqso92uLZBMUa0
 6xm0/ZkQ
 E1KqIcpdKONfPWK7ZOsmBMt0LbEVQ7Q/iDvA8LR3y9o0D6bWvU8BPi19q+FXhuUPtnAeD7pyMEwOfTGbAhLF+8670RN9VzVw76RB1SRI6xMzFi8XNKET67OSSECqnvqWhwpeCyL24ELbMdl7AAe0fkoxbCgt2ytmBy0vmSETwnMgdp34qhhMpajL8L/f2p6qRZZKX2L8/GH8O3t97BKF1PR9Q9RWkunmKeJeZ43CW7El7500M9N4hrrBKpPvsx6+PcvP+2BhYORQLrrJVFHIdZPnobeVHQ+1mU9rqXmDf0335FOhMPZOsS4AbGcxuNXPZ6Sgujy+FtT8ZiQMke4aDMF5vwxucZ7+wcNQwwDYs3+ebwiI63XtyLUlOEr7b3SFo55dr+ncJOK7e3ou8x4yunVjUW5mM6fzVHsftrAo6UAMwUXSItd5w3rBOdEbdp1EQx3EnBzgg9w1LMwb4D5rQSnxNtdm7PpgwLvGrmA4nXNMIdFU7FU+2sbo+VquaAbLAyTXlU7eVi9m0SK96zRskGCQXWlRs00NTzVQ+NJP4iH0jnrp7D4/MpTZSHHECJXwQLzaPTGES/1VEi7CrmXeaRfpT/S0OD+NJOxAgV+1vWQ28G+Z+JmtG8B9MriD0By/Qtv+qL2/F0IP6uVQPNF6H4mMZu+WqsKcQhr0H4OqzgZBKO5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 03:35:20PM -0700, Nathan Chancellor wrote:
> On Fri, Sep 11, 2026 at 06:07:30AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   50d05c7c76c96b90462f24debacca971d2e86713
> > commit: c4eb7ad32eab13ba64cc452c6f43d518b63f5e03 lib/base64: optimize base64_decode() with reverse lookup tables
> > date:   10 months ago
> > config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/config)
> > compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project d3db069999553568848400c84cbf815c03f5470f)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260911/202609110514.S0a0FD6a-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Fixes: c4eb7ad32eab ("lib/base64: optimize base64_decode() with reverse lookup tables")
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609110514.S0a0FD6a-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 131 to -125 [-Wconstant-conversion]
> >       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> >          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
> >       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
> >          |                                       ~
> >       49 |         [0 ... 0x1f] = -1, \
> >       50 |         INIT_32(0x20, ch_62, ch_63), \
> >       51 |         INIT_32(0x40, ch_62, ch_63), \
> >       52 |         INIT_32(0x60, ch_62, ch_63), \
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
> >       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> >          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
> >       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> >          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> >    lib/base64.c:43:48: note: expanded from macro 'INIT_4'
> >       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> >          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:42:48: note: expanded from macro 'INIT_2'
> >       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> >          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
> >       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
> >          |                                              ~~~~~~~~~~^~~~
> >    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 130 to -126 [-Wconstant-conversion]
> >       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> >          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
> >       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
> >          |                                       ~
> >       49 |         [0 ... 0x1f] = -1, \
> >       50 |         INIT_32(0x20, ch_62, ch_63), \
> >       51 |         INIT_32(0x40, ch_62, ch_63), \
> >       52 |         INIT_32(0x60, ch_62, ch_63), \
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
> >       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> >          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
> >       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> >          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> >    lib/base64.c:43:48: note: expanded from macro 'INIT_4'
> >       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> >          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:42:24: note: expanded from macro 'INIT_2'
> >       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> >          |                        ^~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
> >       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
> >          |                                              ~~~~~~~~~~^~~~
> >    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 129 to -127 [-Wconstant-conversion]
> >       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> >          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
> >       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
> >          |                                       ~
> >       49 |         [0 ... 0x1f] = -1, \
> >       50 |         INIT_32(0x20, ch_62, ch_63), \
> >       51 |         INIT_32(0x40, ch_62, ch_63), \
> >       52 |         INIT_32(0x60, ch_62, ch_63), \
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
> >       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> >          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
> >       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> >          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> >    lib/base64.c:43:24: note: expanded from macro 'INIT_4'
> >       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> >          |                        ^~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:42:48: note: expanded from macro 'INIT_2'
> >       42 | #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> >          |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:34:42: note: expanded from macro 'INIT_1'
> >       34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
> >          |                                              ~~~~~~~~~~^~~~
> >    lib/base64.c:58:18: warning: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 128 to -128 [-Wconstant-conversion]
> >       58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> >          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
> >       48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
> >          |                                       ~
> >       49 |         [0 ... 0x1f] = -1, \
> >       50 |         INIT_32(0x20, ch_62, ch_63), \
> >       51 |         INIT_32(0x40, ch_62, ch_63), \
> >       52 |         INIT_32(0x60, ch_62, ch_63), \
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:46:50: note: expanded from macro 'INIT_32'
> >       46 | #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> >          |                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    lib/base64.c:45:49: note: expanded from macro 'INIT_16'
> >       45 | #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> >          |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> >    lib/base64.c:43:24: note: expanded from macro 'INIT_4'
> >       43 | #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> 
> I have not looked into the legitimacy of this warning yet but it comes
> about from a recent change to fix -Wconstant-conversion in clang:
> 
>   https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e
> 
This looks like a false positive rather than a real bug in the C code.
The warning triggers because (v) - '0' + 52 evaluates to >= 128 during
macro expansion which overflows s8.

However, that branch is guarded by (v) >= '0' && (v) <= '9', which is a
compile time constant false for those values, so the branch is never
taken. It seems clang is diagnosing constant conversions in
unreachable branches of compile time conditional expressions.

Regards,
Kuan-Wei

