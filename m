Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B12C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4101C6B0166; Thu, 22 Jan 2026 06:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8636B0168; Thu, 22 Jan 2026 06:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307D66B0169; Thu, 22 Jan 2026 06:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE8A6B0166
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:57:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA75F8AD20
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:57:43 +0000 (UTC)
X-FDA: 84359450406.02.1629FB8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49BD514000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:57:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CW2WiCbJ;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769083061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMLwKCniWDUnyDsUhQOOQuT7b5U00E0bQrDCPBQiDqU=;
	b=gwgBdC0B8Or17fso4eOhGlbIeLfIZ92BZL/UUw3fzvWceyXkrqwmsb/iNFoFljeFcyW7qO
	t5qpLYrd3uuniSItKWTWKNxGqemQbvuTMQgzGNoZVi2y3MuxEpVdoXWeMpoNZQ4ck1QLvJ
	GYI6TgAAzhzo/fM353ROWpoZV4bKYDg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CW2WiCbJ;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769083061; a=rsa-sha256;
	cv=none;
	b=e/NrkR6EOwzu5dQ/pRhu12tEfpzX/gqoLmFtxoi+/DKbPDufRoFJZdFeRE13bVpHDpVezG
	5hbQ945I4wzStKWJVh3nOIt9KnESnn2uuwd6JTa8aPltK+J7FDht8+nF5wffuY9eISF0eV
	agMbaCKrE3rZQuXBRCyMzH8oujFQ7pw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769083061; x=1800619061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YA0QC/uuVi/Pla7THUSaJVW+WVYLDQx6KC9zI0/c4G0=;
  b=CW2WiCbJ62mFwsXlPm6IfDlz5jjG1MI9Qgg+wpCNedtfXd2F/29Q7CKK
   T3jed2E/vQ+YFvOkaJseyBdl+1fh7AmsDAoc+C2FW1dWXLQYFnZqVIYS2
   +X/fRZUdENsGGf2pY32N0mlyIZ8BOPiWVdutu9DDCmR6CyHq7Z7kFRBHn
   Z8QxdO+dp1gSJJxUe5hAF8IvsiNEZHjWd+qJnmlt2J8HQ2oogo8H7t9U1
   roudKV3fWV/FMQT1sOryT3YrFj1d8nIhXwGnol8Y3ej1C24E0toJy8YQR
   4cuQj/Z6sT4Yn28LpdEnmqREZO4v0vokTPbs2ZXlGWPthsbo2VszvSc5s
   A==;
X-CSE-ConnectionGUID: 0dqNAFs3QRmo+s+6E6W/Bw==
X-CSE-MsgGUID: 1faD72vnRs2cB00n84wm3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="69340137"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="69340137"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 03:57:40 -0800
X-CSE-ConnectionGUID: Ql9UBEfsQDOWEC2fNwU64A==
X-CSE-MsgGUID: CI9rWv2OTcaAonwn5YcYJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="244323105"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 22 Jan 2026 03:57:35 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vitJc-000000000Un-3JQD;
	Thu, 22 Jan 2026 11:57:32 +0000
Date: Thu, 22 Jan 2026 12:56:55 +0100
From: kernel test robot <lkp@intel.com>
To: Lyude Paul <lyude@redhat.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: oe-kbuild-all@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v17 10/16] rust: sync: Introduce lock::Lock::lock_with()
 and friends
Message-ID: <202601221246.Qfwh5Atq-lkp@intel.com>
References: <20260121223933.1568682-11-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121223933.1568682-11-lyude@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49BD514000F
X-Stat-Signature: iwzceesoejwah8k96h9bcohw7ktk55ks
X-Rspam-User: 
X-HE-Tag: 1769083061-384188
X-HE-Meta: U2FsdGVkX1/hWtQFrlNvrWo9I6sTAWEd5XC6NUimCp8dptGlP5sGSzD2LLSXA6zGdQXR8QnVOjevjodIDZafZpH2ja1BBXGPba7vlJ2yXT1LTz3w6o7wNQ7noPCtelZ38HHYQ7AyThOzJ9kjwgFIal0NhivSjU1YdGO0Yu2ktb1GnewPil0cFp6ttrV3ScFAQ7iUh9J8R17RvvRt+76KexV7iZkZV67oLXKV29fgeJzHBbTPWCN9vU0RA64eGTUMhXCObmTZbBt8v5ntYnbUv+N3FYJh+rwElDodsxkzT69FJB+WhCNU0k63VK8kRb5woCkuJ6bFgX+ig1ZFp1RajMaPY0Lp8CC3riMLTsUBPBnh/1V+biWQoDo0DhhR451awQoBpK00dE8vOL0U/FgbpTf9cdqw9+ftTY7QZjK+8R4i1PPxF1JQJrpnFnzHR2aINmF8L14FXZfKvQp9iOJCX4ys9SWfdFsaZ+ZcqK+RJdhrSyYgtpnHMx9zfwzK3X4YcUr4P5ByD0ZRC+1zWnO5sTmAxdmQoixapGHAxZgbNUZV9hr2ryqtW2D9tcfxiA9G5D+LAIsnCE6r+GCQr5QglH4Mf1dQQ+e2s7R4xl69nU03y6K9qubCgciuigGIcxUoxRC3C01gNXbFjMPNyrU0fhhwfvv2U+HvC0jmuH1y/V8N+S6yeNFlSgDgbnew6g4RAT0IYG60MhQQpKGKjDXb4a2oKbtbReNR4ME0YPVP+L6rt1Cb1kPn3BxXZPPBoDy3j0q+mdd1tAe7blegZhmDnk4eb++/1aU3xKPYVgzPMzH7s+84Mo0kunMhF2S7hk/ZXmor4Ce+LnhIXCRPnBg7xTedLoZksniPoc1FvOny5KUhj2Tq/7dkTUljJBJM0KectwxcEslZnmt3Ulk7nQF54U3hV6cM/HDKOhI/afVzYgp9RMbZt4+sHUOzWz7m7Qnjl9OmJlTu31iBE+ZH70m
 VNZdZiy4
 rs6T6B46Ts6/rgzXdKAnaGI0HjImEWZXxRIjluRzz9ruRo60pIW4Fd8V81U19e2rTyGD7E7Fnc4JU0+be4tScXQm7xM1kaHuC9r+IomzJ886sfIcgCNFW8n/0HW6Anj8Oo62GcoRJIn89U9sG3bxAMnOybug/aIydlDj19dZy1ItO1sbQAwRYAISOwZvP0ILHgFscCjLmDWw3ZaVweENJD2tTgNNUNr4rDQnCA8BhLjz0AarO0AzzHHH/SNujeQPM0uv4668XzpikdxwPT3BSkY1cMy2oagpZIVVQF9rjwpRhM/mXvDoYkmVBKeU6VAZiFQyHPBMzvcivBaPkKFA+E9v3yWOI4G+uHMREqBNjueZkL54XRl+v4mTwwcmffKGf/pJ+xsWvS1LLGxAstmpXk7zEV6qUJ+KYDZnugk8U8IFPhtsQdyJS22oRXmDOm+wUgO8x6Ig4n1NVZfYrqxq8BESUqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lyude,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2ad6c5cdc89acfefb01b84afa5e55262c40d6fec]

url:    https://github.com/intel-lab-lkp/linux/commits/Lyude-Paul/preempt-Introduce-HARDIRQ_DISABLE_BITS/20260122-064928
base:   2ad6c5cdc89acfefb01b84afa5e55262c40d6fec
patch link:    https://lore.kernel.org/r/20260121223933.1568682-11-lyude%40redhat.com
patch subject: [PATCH v17 10/16] rust: sync: Introduce lock::Lock::lock_with() and friends
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260122/202601221246.Qfwh5Atq-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221246.Qfwh5Atq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221246.Qfwh5Atq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> warning: unresolved link to `Backend::BackendInContext`
   --> rust/kernel/sync/lock.rs:39:27
   |
   39 | /// [`BackendInContext`]: Backend::BackendInContext
   |                           ^^^^^^^^^^^^^^^^^^^^^^^^^ the trait `Backend` has no associated item named `BackendInContext`
   |
   = note: `#[warn(rustdoc::broken_intra_doc_links)]` on by default
--
>> warning: unresolved link to `Backend::Context`
   --> rust/kernel/sync/lock.rs:40:18
   |
   40 | /// [`Context`]: Backend::Context
   |                  ^^^^^^^^^^^^^^^^ the trait `Backend` has no associated item named `Context`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

