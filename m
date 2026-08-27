Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61602C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7E56B0096; Thu, 27 Aug 2026 04:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F646B009D; Thu, 27 Aug 2026 04:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5F26B009E; Thu, 27 Aug 2026 04:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD226B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:37:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 670BF1C1496
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:37:08 +0000 (UTC)
X-FDA: 85146394536.06.C4FD0D0
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEFA340006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:37:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oBvAIZyH;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819826;
	b=ahGz7jdgxY1YbMDPal1ZJ9HLfgAgsuho7ziMuQW31OFg3kcJjipdE7rJq82uiQXuDmJj0+
	EswePW3Zx+JK6buJeMitRs0UV4K43OwI3pHjPaEgkkhHeIjoVUIAhih32BXdkTw44Tf+UG
	LRcbuEmgDR1va0d0UxBTNN4qNa5QRuM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oBvAIZyH;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxZheOU3heq1Rt2uci8mom6QvWxLgzl/sBJmkwWwCSE=;
	b=pbIi7zaXujSeYPRovRIghpwmZNpTFLrRwRwLipN4w+9qA8HeHfc+EwkH8ssag3Pb4LcgfH
	8/bEkB2wx0iiPpgU+3v6jwzBcupFV9UUIFyLOkcn38iRwtdU2r23AjjaaRlBbWXdnreW+h
	mgjGVGdJTDSNdv5XXJXw16Mb+TLXagI=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1e1ff659bso108963a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787819825; x=1788424625; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LxZheOU3heq1Rt2uci8mom6QvWxLgzl/sBJmkwWwCSE=;
        b=oBvAIZyHTZnvL0cRI6z+gqDvRqbsdPzDXRMc5xxOcdBKDai0Wpx6mlxozeDeVAnojk
         NPQOc/tY/QDP2MUcKLrhq9YpHASSADy9m1T9JUmLESSxePzbPQU9XHfwSleVfs4bNe0M
         ZH34jOfPDSo69YTrmBzhcbg0nO2fZYDHAtemgqKePyhmB5CCImnAVqk02Q6bPsR5GU50
         igYEhCNAyAdNRMfR1BZfzot9W9hvLSuLQ+1b3p1weypLBW473N2HiWKI7QjmAyByBjU1
         zwf97Ip/crjU5+tQyruVb7kL7Z63XABomubUkAiz61qUeHELckf0u7QYfPJZ1S4jcij4
         3ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787819825; x=1788424625;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LxZheOU3heq1Rt2uci8mom6QvWxLgzl/sBJmkwWwCSE=;
        b=lCoZJZrVdTiOxKsutxfyM7/0kljwl199Mz6WEaN3cmlNezAPWMvnwRsaMHz+QWoqPN
         W5u7ca9/+VaHLlNRGIEKPQf9fYSeOEVkzQF13ff+gdroeq8g4CCmqS6eEUrtTi70ZN40
         1FmieF9LIwVYdVcqZNymauOqT4kywG8DRiVIoH+sSL4l8KW2XLU4+BYvT+Um4jlQM0UR
         XG6PsYgmeIGat9hJ6JKUkU/q2OvkB9LevrCwFIhumSHDboMmhrBQJrX5rLpqiSWWO6i9
         5hJc856MMaZnAUzevlGeFayg4IOlkwqyhUL9I9Mrj1L2NJZsY6JJuieL3VAQXcObq+EW
         IZNg==
X-Gm-Message-State: AFuF++leO1AFjKVapAnzGty95u2f0ONcX0y9WVXLywX50xHyGZReqgxA
	piZ7AxRewjldFbPa0o/nFhkLVvfzaf1EBe5vTgha5zD6VAeaRCKUO8ZM
X-Gm-Gg: AR+sD11ugI5H8wQlzT7PVD8E5eQSWNbdUHI3m2VdpWKzS/XqLHYtFFJTvDT299EIUc1
	W8ZLEgfAoN38tLGyeJ0WWSdWvtrhxIbTS7YOGalWk91osbu+uoc5/tTyVeanpYreGfLzijSKtjf
	tEmB7aOKwzDGxp0ZZnyIu65SuaVR7U0OnuWlXsd7e3Ci8JkEBKWs7ud+k1f+Imh9ji2Thgoj2Id
	nrQmlokwXK+CoZ77Kt1Ctb0sgsXmn6AJfWITalUg7Y6PN1tU2KajRhLDTsfcBOy4UZnFUdevTP6
	lM6eGDawp2lVuMPljvmcOXnMkkdLnbt7D6eTyHx4pO0wVlpzsL7jRqtkppGgfMdlKidn7ChqScJ
	J3JcpUT/OyeXJ5sQOIt8eR2oPkKSCFvpXXDHhxG3/97KNFtqfqsBCyl3cv2W8DusErhyb1QrUix
	/NN94mCenLHE4zmbnOuOwV2+/bbIaPm7MHKhpmW/q/+Bjcv4L02tAcmgPMjTXIzYG9VKV4Py4xM
	UL2ceTrHrKGuNwG5J/n30K4kFksoS661Pd5ZNST4xjarbvaE1JK3B1O0CI6RokeqJVid6p1CSLa
	vJpWuQ==
X-Received: by 2002:a05:6a21:4593:b0:3bf:9b61:f7ae with SMTP id adf61e73a8af0-3cf8413dffdmr30029671637.14.1787819825412;
        Thu, 27 Aug 2026 01:37:05 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae53e5sm1898674a12.7.2026.08.27.01.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 01:37:04 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:36:59 +0900
Message-ID: <m2zey8ufh0.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v2 1/2] selftests: run tests on nommu architecture
In-Reply-To: <ao2aTD1ZGObPfp4T@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
	<20260825015945.141739-2-thehajime@gmail.com>
	<ao2aTD1ZGObPfp4T@gremlin>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AEFA340006
X-Stat-Signature: ebx6kzaixkchuic5qc87tfe9befusgew
X-Rspam-User: 
X-HE-Tag: 1787819826-362677
X-HE-Meta: U2FsdGVkX1+5DNnhzVtJxj7d4GfJSh6gaefinX7W1kCOAea1dJ8tqWnlfGQM087/27tv1qctOAMc6e/U1UdjWzNyqVqQmRnGJIAEGfaTz9tihevK2XrI26EqO7YCe5HTUqP1DTtl+XlXDdNTQxHwqPiphD2kOPwjdHErdU71fDs1Gu3GKEkoalD9atuvKKOO6QvRIs/FtGKOZ2fP5VTc6cvotrOodrU/AOd6UjKoTt09kPRt6pVFADtWYa7tjt7dYD4O0n1nDj6xLi+CQQBJUCdDDCIG2AsQ2QFWnyQWRD739m+/sLmigRIczO/InDuZQJeOgN9a2LjjLLBrqVsO7y6zHvmCDFpA3YkgHmTj31yq3N7qaSsOh++wzxXDYlYdG/twJcYwrNU3DYWXRx3vcWOLF6B/y6VM3IDWiUnXbPQ9q9GWNSbT0zAQ+37EIYiT1361nRSA53TXFjG32GBmH4MC56f/isszuMa64q8vF6OBcQ2D91vgOrQhuhhIqUZYNHGqqLbm8PossOwlBbVC616WKiHNtcDy7BUpWLLncrHQOdMLI2iZAZ7vvvbtsxvLDeVbzbjY7rwp/YzPpl8C477NRh1ekSrFdukAI3TEG1BZ+opDa49ByxKugACbsMdMtTP54xqhs52wuElnGr8TzHXIjs8x+08hzwAQyWCfuyLEK9beUz6LJrfuevddhPv0Vn+S3WBuHErM1dAULK2GvQNhLmUTAMawFLveTCOmSfzDDIK9JalbM3ZYJ6g2LzJ41/0zHEHLQdcbkNeVKq+sGVOlz8Sc3ZwtcgyKrHxfsymgjmQhSzvDlfHNsuVNTBuKodmHVpKgFW1Whou+kbTqsg6t4JwZuCO4HA/UYB/BHT49H6YFXsDr9bNNFH6nQyjsP9EA79UXFNpWPiZlJ0lBH4scj/lXiAcG9Tb93MipXqwH1UkIeYbZb5rK62LZFZo80GtFhtfOHkavZI9B55b
 ao4i31CG
 d9r1Yhqw4RmfJEXfq+afdRzhVuUbS8zspGofc3DGylTRESI/TUP5sSQdNBL8rsb5dtag6tSJ44NIdiI+zo/DFHiJ3ZNekEy5KH4sl57hgwkjhvGNmKOjzpMh1Gt/lhdh56F+I+mXQOiGB4fdTVDRGvDnj4y1YGz7qsohIGwkf7XkeTVC8qOOP8yicr5STd7kb9Y7VexUwhNW8nbwtPFPIlFHYxsu20Dg3r4e2XJLIL2+1dVaIXhxLnb2Q3IG2fQp+hienB9IZ887Tvc/xg1njWkQtW3sCmKdWl0cK/i/kum+kIc4qD+18qZ7292QkWMGo9ybzU1hdtgIvAU3srQUd/AEtxxTu4R8gvX9r7ei4261mEuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

On Tue, 25 Aug 2026 22:36:22 +0900,
Lorenzo Stoakes (ARM) wrote:

> > diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
> > index 311811dc55a0..7287d8290b6c 100644
> > --- a/tools/testing/selftests/kselftest/runner.sh
> > +++ b/tools/testing/selftests/kselftest/runner.sh
> > @@ -38,8 +38,12 @@ tap_prefix()
> >
> >  tap_timeout()
> >  {
> > +	# nommu doesn't support timeout command (missing fork(2))
> > +	if [ "$NOMMU" = "1" ] ; then
> > +		echo "timeout isn't supported for nommu"
> > +		$1
> >  	# Make sure tests will time out if utility is available.
> > -	if [ -x /usr/bin/timeout ] ; then
> > +	elif [ -x /usr/bin/timeout ] ; then
> >  		/usr/bin/timeout --foreground "$kselftest_timeout" \
> >  			/usr/bin/timeout "$kselftest_timeout" $1
> >  	else
> > @@ -130,6 +134,7 @@ run_one()
> >  				return $KSFT_FAIL
> >  			fi
> >  		fi
> > +		OLDDIR=$(pwd)
> >  		cd `dirname $TEST` > /dev/null
> >  		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
> >  			tap_prefix >&4) 3>&1) |
> > @@ -147,7 +152,7 @@ run_one()
> >  		*)
> >  			ktap_test_fail "$TEST_HDR_MSG # exit=$rc";;
> >  		esac
> > -		cd - >/dev/null
> > +		cd "$OLDDIR" >/dev/null
> 
> Hmm, why are you changing this bit?

on nommu we cannot use /bin/bash (i.e., no fork(2) so, we use
/bin/hash, a busybox-offered shell with vfork.
with this `cd -` (standards specified) isn't implemented due to slim
requirement of that shell (I suppose, miserable...).

thus this workaround.

> >  	fi
> >
> >  	return $rc
> > diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> > index 261e4df94d9d..0d05946a5e7a 100644
> > --- a/tools/testing/selftests/kselftest_harness.h
> > +++ b/tools/testing/selftests/kselftest_harness.h
> > @@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **argv)
> >  	unsigned int count = 0;
> >  	unsigned int pass_count = 0;
> >
> > +#ifdef CONFIG_NOMMU
> 
> Let's not prefix with CONFIG_ :) I think this is pretty confusing vs. the kernel
> CONFIG_xxx flags, esp. as this obviously inverts CONFIG_MMU.
> 
> maybe just 'NOMMU'?

thanks, I will remove CONFIG_ part.

initially I was trying to pull generated/autoconf.h into kselftest but
it doesn't do much compared to many modifications (run_kselftest.sh
needs to run independently from build tree) so, I used this macro but,
yes, it's confusing.

> > +	ksft_print_header();
> > +	ksft_exit_skip("kselftest harness requires fork(2), unavailable on NOMMU\n");
> > +#endif /* CONFIG_NOMMU */
> >  	ret = test_harness_argv_check(argc, argv);
> >  	if (ret != KSFT_PASS)
> >  		return ret;
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index f02cc8a2e4ae..fdb895967768 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -97,6 +97,14 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
> >  TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
> >  TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
> >
> > +# detect if users request NOMMU build or not
> > +# User can set NOMMU to 1 to build/test for NOMMU platforms
> > +NOMMU ?= 0
> > +ifeq ($(NOMMU),1)
> > +CFLAGS += -DCONFIG_NOMMU
> > +export NOMMU
> > +endif
> > +
> 
> I wonder if this could be put into testing/selftests/nommu/something.mk? Though
> I guess would have to be included for all builds to account for nommu trying to
> build any kind of tests.

yes, in addition to moving to selftests/nommu this can be more cleaner
initial introduction of this target.

thanks for reviewing.

-- Hajime

