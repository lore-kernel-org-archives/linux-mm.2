Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E06606A322
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P6AkJ5WW
Received: by kanga.kvack.org (Postfix)
	id 91CB96B02FD; Mon, 19 Oct 2026 13:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEC26B02FE; Mon, 19 Oct 2026 13:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE306B02FF; Mon, 19 Oct 2026 13:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54C286B02FD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:08:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D682EC07AA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:08:08 +0000 (UTC)
X-FDA: 85340008656.17.79588F5
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBAB14000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:08:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P6AkJ5WW;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9Rf2ubDKz7ML74MPtfck2qyU1vrqP5ztLplisyq7v8=;
	b=mujwtAez237hRPBVedvpFVpkcUeuMJzTS99epq57pdxDfbnim/ciCWFqXtE7QCFK2Z+pnq
	YrCrUEAaKjKUdjgIv2oxSb0vgfVBEvg23inKmhj2uf/x9h0n88L8ccqAZxT2M9ZkI2gzdh
	ZJ4LvNsaTNhXmPRYJl+UdfA31rptd/I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P6AkJ5WW;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429686;
	b=px8RQDkOM1VaYTSm8s2y1+/sGr0LaZBYdOxeYbgDIOfmBy+Vefcms3hA5PFXD6MqpDyA1B
	4bTqn7G1x9eoAxBU9IYffPqJDEMpEQHcp+6uWAwLJGOI2yvc0chxPjJgjQGL0ySWtjEy/0
	5xDz/X3cvm4kBes+FMMQ1ohLvqz/Y60=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48df54150dfso1829057f8f.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792429685; x=1793034485; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z9Rf2ubDKz7ML74MPtfck2qyU1vrqP5ztLplisyq7v8=;
        b=P6AkJ5WW92lSK/yEh78hwWk7pHbX7aMB4MMMesk5la6Unwv0mJRnDyxYSdT3YoNT0H
         WVEFMA+iq5mu9PEkocvtS0nJvmIqSXoLN/seDovC6lVZikjmIacxMRrBGjyJAk2gc2MM
         XrDbB7LH3np4RsfZXF0tcvz7a+iQ3qC07uYIjv8kBOShZdJdEzD7G0LrKh4nBfXVqPco
         SLbMBmC+aMetokj3s8FOmtiinVyP4p1Z5Ism29285jOmR/o/Idist58Ax/X7lESmdLFG
         kgU35tQ50IpOhjkCh/wq5/ZimV48KEzo8ZwNvcdNA5KNyPrKXavIMgwrYCcn2AmhdmTx
         j8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429685; x=1793034485;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z9Rf2ubDKz7ML74MPtfck2qyU1vrqP5ztLplisyq7v8=;
        b=jaZWr63oMtpGP2sijT1JkrPlmPwIWfbfvAG5bLkx0qP0T9IMVwR99E1JKPaalNbUYA
         9Ol1VLgm3gs/+T0aP262Z6l9to2Jqe5xuJ5k9djd4U9vmZgcf71ifon1l14Ag6FEKih1
         1E7ttG4Uv6mX492Vk1th9+MheOeUOlilNARXjIfqQGiIoxG81sX1Qu0++iMwMU7kYZPb
         5ko5PVLN2KsHewETdGpCWQBQMORG7xQg4o8Itsbha9znpqei2ONxlr0CpikJTFemAuAC
         KsbWC2XiaEnbKx/ueeP4g0dsq6lFtGDDczSRgFdm+/9SlEqQPOiGD8a2XDdTCFNY9VVT
         o8ig==
X-Forwarded-Encrypted: i=1; AKwUvBwMHgMONZWnbMzc2ntTbARA2dzf6/U8m9+UR8X1fw3sgGqllgW6MGdBz78ETUavmYg7E4iBsiz1AA==@kvack.org
X-Gm-Message-State: AFq9FYIESYTSU85Icthr5p9thL9akPNnE0LSBm8LsMLU9lHKpM5B71jn
	Z+1HUJK0Gr3acDe5Wq6+aqFNzRdoCP1Po95Etmc9fUgFRSO9oUu3yqIt
X-Gm-Gg: AYBFou0CRN1MbGv+N+NAjzFyEsOFwD+3KxOjrw8ktT+bjW1j7RwvA0T4L3AiRGomeKW
	40eAq4zWL5sE3emq/JjS0TuEDdkk9VUL/esR/viGODNlwv/nDjaFXLUz4CVJhIoGcovwZEgquci
	INBQacFDFFei+0lWP06ankQVvD9HlpFVhlrbtwHInnbee21kgVnfvsnLGQZChOQ58hkYy9j7ajG
	1HU3sW2LwJIGgJYXrwgKyzTNyPM4LNjtl03LYRVagxpU5JOzuRVLlHQN+/09qmzAIDP+FGozr/I
	X9Hc1zMv+1Nii8o3VGWKa0/BNKi+XZDKJh7UgQkp8KaWlTlzRygZ+zCZy/IPIPH/LGuoxBdNcHR
	vfzivMjj/c5GrOJ9nZq4LkpXH2MhYUXu3MpjiaaQ/bVayTPMYHMZehh1m1rBQ45eWxNiW+7UVh6
	oafSkiW1oswoiD18dxlw42qoYzdr7W7Sa5eiH5zU0G0fLCtHphp40QT8lIHP4pvH7018XqAtV+q
	4g8CCYzH87YD2fwO0ux5bPypZnnAHbLg3U=
X-Received: by 2002:adf:e78f:0:b0:48d:ff81:5201 with SMTP id ffacd0b85a97d-48e07f99fa0mr12300471f8f.41.1792429685165;
        Mon, 19 Oct 2026 10:08:05 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d818237sm146817f8f.27.2026.10.19.10.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:08:04 -0700 (PDT)
Date: Mon, 19 Oct 2026 18:08:03 +0100
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek
 <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
 bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>, Lorenzo Stoakes
 <ljs@kernel.org>, oe-kbuild-all@lists.linux.dev, Linux Memory Management
 List <linux-mm@kvack.org>, Luis Chamberlain <mcgrof@kernel.org>, Andrey
 Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Steven Rostedt
 <rostedt@goodmis.org>
Subject: Re: [PATCH v2 next 03/15] kallsyms: Improve selftest
 test_perf_kallsyms_lookup_name() output
Message-ID: <20261019180803.3ff8c35b@pumpkin>
In-Reply-To: <202610192356.CItNLOke-lkp@intel.com>
References: <20261018155206.132411-4-david.laight.linux@gmail.com>
	<202610192356.CItNLOke-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBAB14000B
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3nd6gicetkxdk1rahppsuaoi1kmaq7sx
X-HE-Tag: 1792429686-490558
X-HE-Meta: U2FsdGVkX1+a/NlXVBZuPqfi5OjVDu6MJ6Kxm27Mxmz853CCFkBHcxPvdjFcAPTj2cEwStk5LC4DKQnCVZgwVB9I/etnr+Dxo2fsaYl2bZbPOv2mKDLkmO+5OC0Twgjezygqr+2c1QbjXW+P0sMPq5cw9wIaZSdPHu8k3mkIRFesDExRY4Clb0pNtoBPzaDbNauAYx79mpECms0P5HI/QqlvuHQatCr0M4N4jCDe29hkvocvovNKy0BWiTmmcAmObh/hWF8g1wzXmUp/fsXXmxJEZMqoXnv4Pgs09tU6D+Uj5gc/oR7HCu4qDEdxL5ngAwcM9YYC78kg8NCGjzfIggpmKj5M53HbEOnhMQQ4sh69czdNCTPwr61vYsTB1GcOgZCC88MfNSHVYZSfP6ORSXOm1eNZZRUk6ZEjNgKcIX/z/vjHKBBswvGMm3WM7PfUOLqmjlPZe0xkLzBbsKw7Yrw00eXgIhJadJaJgG8wurmLJrSNmjnurihJiigiElsF3ExSmtDRstWxJFEUu/IGggSzvNxLqn7Cm5cbQSRgj6sKbHbXHg6TTLWMMJKjJMJTH3Qqp+QFiTwCXuD+poTQSW0372hPBMHeu/EowkoFuOH3SS9gnSxTXLoRuCHbRu7KmXernO77xApCChssxRWK+kHBzDnzeYaX9k78VIlIKcL8Sfu6cgGgLs5UoGoUoPnVcrUq6EfJpnl4zeZYfXOcTDnP97RdVXAnv68bE0NDbV6pGEy8P9krMRDyGjZLOniHmh+ohGJFKhQj3RYrMMARZHH36jBEKZxpnbhq4CAjE1n/k6WwCGvUPM8Zz1P1M+hWbOUSO9EnUop1RImUXSgiUFl2LyJz3q6EArMQeH7DrlnYAEvuIleemnLHbAxj/Ljswzw85scJR7m58jFvYUdJRkaMBTiksaXXIWgDr3j0nsLs2imFusholMTfdPmRZjE4McJuaO7OLdGd1E95hwW
 Ojygd43D
 H7zhj3q4FjODGO1SDNcqRf/rJyDw14jm4JlGncQP1ORSxIqM/0tRrEoE8XY1u+YHuCt9X6e9QqJoXczL9CNVmwhGYqTmlawMDzrn4C7KU0svYTnnRYEYNpUx0B3u4tQc477af92WP8qU8i3vbonCpT4Xfccgjhms1+vec+AeBNpKfxyBPthYhDEOIQgt6C5FkokdXFQThywiI0KTqo89HtqyBYi/Muu2mY5u47uD7C1LwcQJ16AWdpVhw7pvyNpbD0bcmY6CFrk/U1g9sGTcaEELKTKlYpm9h60b7oDR7UkjCR7sXFN5soqeYKKpM+a8WmB6tJuTeUnr/A7kO/aDi0bggxs6E8OMG6XWErxRST6BzV8y/c3HAi9kS4CtVhaIJlqOfhOhhlBgpua1sZGLeBchgUoEKC6LV/cM2hw94qoBcHRgBuTewbDEZtPn1TWIUOxeT+1KsS5Z+jlttnv6VsxXLyhe1UuhOI6WeuS1UfOvduHw1Xm7i/hrR6ErA6Zq03CaJePjRoAEpCADnhQT+JFaPireZMZTHJR7s4K1OJSlswAylw0U5IKGzUNbmNDj5ZeRULdSB1dE7pYE8ZUouYz1fHKmNx87iQmQD4/fVDrvyUbmvIVcwe6NeMZ2+KhtzrcLbQsnuIoEwRsSn1sZE1LT+ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 00:07:48 +0800
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
> patch link:    https://lore.kernel.org/r/20261018155206.132411-4-david.laight.linux%40gmail.com
> patch subject: [PATCH v2 next 03/15] kallsyms: Improve selftest test_perf_kallsyms_lookup_name() output
> config: nios2-randconfig-1000-20261019 (https://download.01.org/0day-ci/archive/20261019/202610192356.CItNLOke-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261019/202610192356.CItNLOke-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610192356.CItNLOke-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> kernel/kallsyms_selftest.c:70:1: warning: 'The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun' defined but not used [-Wunused-variable]  
...

Already noted, it depends on the build options.
I'll use the same 'trick' as done for the other static symbols
(that is reference it from a non-static function).

David

