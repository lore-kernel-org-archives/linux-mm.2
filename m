Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060C7606AAE4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=joUJU9WV
Received: by kanga.kvack.org (Postfix)
	id ECBCE6B02E7; Mon, 19 Oct 2026 12:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BC86B02E8; Mon, 19 Oct 2026 12:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A1B6B02E9; Mon, 19 Oct 2026 12:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0026B02E7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:08:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29928C073A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:08:54 +0000 (UTC)
X-FDA: 85339859388.22.2EAACFA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F194C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:08:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=joUJU9WV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792426132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=poUPYDGsy3A3qaMJ9gfhwR/7k9/rzOgPJFd+QviZSu4=;
	b=25MUdjuy4NxMDaf4zdrBl63kF7OnoLQKjbFvnKG+GQ/79jFA2M241+l/AaVBkAhB8kk6by
	vq5vtK14U0GVGlcb99UGuOxnrgAr0+ZFQjXpeMt6sZI7rzBqOtUi41ZDJFXVKIgz6/m47D
	UEqNO5VhTxUpQedbas0dEqqW3Uw8H7w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=joUJU9WV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792426132;
	b=OMy63YqAqIDu+rwW9K4Ig7XJSvIEPo+ItSkxtMAV2cqfta1DXiYayujvHVpjo0wdAxNYOU
	DyGI6nSTEtXStGWjqzKS4hhZF0Ol4EkJzhCy9ojdV11b4uYw62Iwr69Lf6UWPP5JPMq3s0
	3W2kjgHj3xy3lhQ/5Y42QWHdKBwob+U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792426132; x=1823962132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tYhhhR8eq9pKvNN5fuGWDReozGHrqdOYBbHVTcKvxBc=;
  b=joUJU9WVg50ZKwdUKUkiikzNtrGfWI+vD6v7NEBNbnrg58Il7N1nqpa5
   xYoDemHDR7gRqjy+xCpUl6ndLNoUUd91RJ8Pn9g6V8ki3wKUKfiz58tjI
   SiYj8v8WVs5vik4UTAkwJ1MHrofiMjMPcHH1JsxrbpxQ2HYcAo7xe/KKd
   y3hL9+vLVHDezM8rJJPvUM5tYFlstSudKC2H5BMfDJEaBd9m/wlqknSiu
   q2Ha4bvzinySZ2lUZ7QwMe6NVmXXE4mmdw5uSD2DMJCN6q+yk+m8cr1iU
   oNJ/6O79+zKkFsgxg/Co9+7GFwb20LjbXclK0CSmCu53T/8l/IRCMkHkT
   A==;
X-CSE-ConnectionGUID: ny73n4OsT0SUJznxGfZUpA==
X-CSE-MsgGUID: 152LJv0MQyy+SoW/Pf2kLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1115526"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1115526"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 09:08:50 -0700
X-CSE-ConnectionGUID: jYCtRLUTTomG131lll5p9A==
X-CSE-MsgGUID: JXzuwFcEQkOgnWp/q2l9oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2452806"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 19 Oct 2026 09:08:47 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIpum-00000000Lv4-1g5f;
	Mon, 19 Oct 2026 16:08:44 +0000
Date: Tue, 20 Oct 2026 00:07:48 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 next 03/15] kallsyms: Improve selftest
 test_perf_kallsyms_lookup_name() output
Message-ID: <202610192356.CItNLOke-lkp@intel.com>
References: <20261018155206.132411-4-david.laight.linux@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018155206.132411-4-david.laight.linux@gmail.com>
X-Rspamd-Queue-Id: 4F194C0004
X-Rspam-User: 
X-Stat-Signature: dgf61gzxa1ynjbuoaimcpkz11qawixu3
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792426131-182627
X-HE-Meta: U2FsdGVkX19UDGhm2LgxRv6SnY/nwqYdXMbph04wsLOXhP4tWk2PeR3edow7pJh2xSgoFoiFTiqV1NI3005llEzMAYnLkudhY5pQv+OK8tcjWldVdKrJZujOl+lRsnemAyQvnN8b7U2pE0dbGXPPKePDhk5H1QcdH0VNGrjGOUjOpOSSRzPT7IstiIR09EOTK+WJE698Fur64OcVhV4jLkmkSBQ5krQXbSAb2+815HrcmMKyW0h14jeXAwDArPYGAUdjBS66k96CLws7Yppm5h8Y40BDoP+mc3Geb4P79c8aaliCkRAQyWha3x0lMW66XbiKVhOLBEYX9S9aQmISP8uYcP9TSZKZBVmwNll4PV5gNXrm0QrxXAAOugc2tO+wdWBWIXXevxQys6N2/t6/ipojpTTDWvt8IN+0NsltySxMr7IZ8edrjhHlKVukjlUxhGv6TRNZAT76WqCxW2AjHcQoy5CGlY28L5DkISY9SQthTJJBsmIiskVNvY7qnRfghITbJr7p3gTi6lyYFHaE0leJVp0jExh03efS0QLhJlZuU4NrVdylJmv5sCHKFQS5E5zZ4hfg4w/DWQJtT6wgMB/0bom+X+ZJLCXhHffiZs6mmIEcgI5YQyiBBAVex2Ne1a6ywv4qH279DxRrQfjKUAGD63f1AEwZtQLTHeBuMpNXB3pQqXHh2IdqKVMJ+FQ+OmjJskUBGv0aLCPuOkM3Aq2OlOcZ5ka3o5/GYU8dWdj3srKxWWyzEN7cJ+lz/Pvvo79aoKjD4Q/GqiGoVLT3PLqn+fPSZrxfIGEoJegRK8y0w3kZ0yIdGr3LksJpJi0Z+BYAUtu0pBwY9hogNcYZFkm11P7iEZ5/7k/z9kysF2CWOdeGwU3YHacTnfGsgQ2YRjR0Rim2++4gXdPPg6l51FrHCA/k8On0qogm0Ril9fnmY0lp6fyxjvb4KWgZbjBPI5iY0j/oQdCLshJBS1O
 qVBJdTWr
 yi40RlnxDtPrwZHM7+563eKm4StBXPxFOXa6xM4IVT/JRnBSkyNG4zdTyk7ZaLybk0GSIafMciYuTEz9UMkqWDWZC9rWseMFXiIktMZPNcmnQAOHRxS3Oh7RyHi2MNJNwSFOrQ3DL66HYqL5/pV1mkcs5DC5G3aUBkmRdq803pRByS9j6ffgKzljjcl9WY+XYDmuXzr52L/WeDDFKwSv0i1KBjU76ABqdcrgqY/FmlnPrnpVmrgz4kgFykhgnJvErfMhZ7LqfVvokVvJ3hxLIL/91D6uU97Dpx8dmyhZMWFU0dvOwE4SU9Ck5+UZzcvwvtQMSY0iTbt9DUI3P0C/w7Y7A+p1jbf2XPJjC+JujG3F0tNxwLvZL8Sj/+Q9TVtfjZ97LQWT22SN+nmN1mf2xCK7THrkvyFbb9A8HDY0d3J7QZ7wkJYBnAUbZ5g6X8z+I1r+qXbBDgDRDdfHTQvzuAnEFJFKugyHI4xbvFyMHxFlRnf5VZ8vhXPFDtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.3]
[cannot apply to next-20261016 next-20261016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/kallsyms-scripts-kallsyms-c-Avoid-overrunning-on-stack-buffer/20261018-165152
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261018155206.132411-4-david.laight.linux%40gmail.com
patch subject: [PATCH v2 next 03/15] kallsyms: Improve selftest test_perf_kallsyms_lookup_name() output
config: nios2-randconfig-1000-20261019 (https://download.01.org/0day-ci/archive/20261019/202610192356.CItNLOke-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261019/202610192356.CItNLOke-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610192356.CItNLOke-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/kallsyms_selftest.c:70:1: warning: 'The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun' defined but not used [-Wunused-variable]
      70 | The_time_has_come_the_Walrus_said_To_talk_of_many_things\
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      71 | _Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      72 | _And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      73 | \
         | ~
      74 | _O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      75 | _Shall_we_be_trotting_home_again_But_answer_came_there_none\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      76 | _And_this_was_scarcely_odd_because_Theyd_eaten_every_one\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      77 | \
         | ~
      78 | _The_moon_was_shining_sulkily_Because_she_thought_the_sun\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      79 | _Had_got_no_business_to_be_there_After_the_day_was_done\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      80 | _Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/kallsyms_selftest.c:70:1: note: in definition of macro 'kallsyms_very_long_name'
      70 | The_time_has_come_the_Walrus_said_To_talk_of_many_things\
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      71 | _Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      72 | _And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      73 | \
         | ~
      74 | _O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      75 | _Shall_we_be_trotting_home_again_But_answer_came_there_none\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      76 | _And_this_was_scarcely_odd_because_Theyd_eaten_every_one\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      77 | \
         | ~
      78 | _The_moon_was_shining_sulkily_Because_she_thought_the_sun\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      79 | _Had_got_no_business_to_be_there_After_the_day_was_done\
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      80 | _Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun +70 kernel/kallsyms_selftest.c

    67	
    68	/* This is 509 characters, compresses to about 330 */
    69	#define kallsyms_very_long_name \
  > 70	The_time_has_come_the_Walrus_said_To_talk_of_many_things\
    71	_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings\
    72	_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings\
    73	\
    74	_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run\
    75	_Shall_we_be_trotting_home_again_But_answer_came_there_none\
    76	_And_this_was_scarcely_odd_because_Theyd_eaten_every_one\
    77	\
    78	_The_moon_was_shining_sulkily_Because_she_thought_the_sun\
    79	_Had_got_no_business_to_be_there_After_the_day_was_done\
    80	_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun
    81	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

