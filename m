Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9685CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078A96B0099; Mon, 18 May 2026 02:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0501B6B009B; Mon, 18 May 2026 02:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEE56B009D; Mon, 18 May 2026 02:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCF2A6B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:51:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89EA1A083C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:51:35 +0000 (UTC)
X-FDA: 84779619750.29.8764157
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4CF3F8000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:51:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=li4M4E8G;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779087093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUlzPozLkWRjKAKl4aEHHkl3uAJhJt6o/2UxSXy0ApM=;
	b=5BQUNy7LF98X56Ebj0HHC8joNz680PskgrHjeWer10MfoLb2uBOp2KUpgmzWxuYe/ImnX6
	qfLy5hXA7CKROqAM4paXD8iyCg8+j9Q+6W/GJCAGgbAEpbAhkiLyr/V5cuGgFjg27pgiiK
	VbwNa0byeXYQ4/ayDdvA9Xb/nR1mF7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779087093; a=rsa-sha256;
	cv=none;
	b=miD4ifBA8kDV+KbAWz2pPFyOFW8CTD46QXoR0/JRPN+1AE3gF/+lPnJoYGnlM+IS+Vk1VQ
	TuHEu8mOea23dQA6B0u1xVfPLqMpfHDir/PRVi1wrf+f4f6OqBz9/bOMfDkxIDm0t5tf9t
	G+joCuSeFzGYGrZFcOkTAIvtBx5vI2M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=li4M4E8G;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779087093; x=1810623093;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=67GeE9/Tn3fyq8b8ao+tLFHkqqzz+lSrMnSeLzKc7d4=;
  b=li4M4E8GzJhuh3Y//ERCAEiJUXqxW5XUZ4aD0hbku/eXeYQNIQBBnzMf
   mOJzfqEsfdY3XxeSlJvqiHnlGpJv99w7LIs9lRwI5r9sxXCTO8j+46f7w
   3tkEdgEcEtb/01elR7XSbEVQJQKIuI9tlcOyR+WC9X1k6D52q0O+I2wuw
   SgaxzLkgXmu/5pn4BinIGm1Dmxx71J4NHeXuBSTHchf7+GwZoLeQu44mS
   Aqyoy+ekIlRRig7oATFODl+0OeT/e4s/my5/li6F+sUhOgsQXPZmlwzdP
   rTzjBe+BrTiay9N0l0bP3cjwdrbTionHowZnmZOMOmRYpCjIXMBYXqjWD
   A==;
X-CSE-ConnectionGUID: 2XyKvh5PRBmbQENCHRY3hA==
X-CSE-MsgGUID: M2FVPrR/TYeLlpbckTUpRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11789"; a="79963403"
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="79963403"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:51:32 -0700
X-CSE-ConnectionGUID: UB7jg0RwQn6CuH916GPu7w==
X-CSE-MsgGUID: 59fKNBraQ8+CsS+HL8lHiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="239592860"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO localhost) ([10.245.244.3])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 23:51:29 -0700
Date: Mon, 18 May 2026 09:51:26 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: move offset_in_page() to page_helpers.h
Message-ID: <agq27i9l1P4rThQs@ashevche-desk.local>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-4-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CF3F8000E
X-Stat-Signature: 8keysw9qrfo4nkenk88ry6yn5sktf6mt
X-Rspam-User: 
X-HE-Tag: 1779087093-831
X-HE-Meta: U2FsdGVkX19hlM5IJZCDEpbnV0iLgB22zksmI1bsKBSIc6AcDtRGe+9PaKUVmP9DUKehM2K9DiUsbVM3DliwEJTR3sw1QjHisBq5mXUDn2X6pYfpHCpNCmc3ScqR4tgDU+PKWt+uv4Vbp84LPJEBg8pg7TsM/3ynX7rk2mS2D/ZDJnftekAli5raVDivIF2/ByKnASWGQ2gvapbCC28hUqGXLB/JlKWhGozlbYbCyUdzV54iZxRGhcRJhuiIWU8hH+oqPfHr+n+kABNG2mtfz4qTX3EdD45jSMn8nVmPuTnW/zozEowO2o/YLO+VnuKnd8gAzLFMOZFVLJkSkljyMFpCZDQ3kAvEK8BCs54GgNZP1rxj/c1drTW8JtogCz7B5ngSKLNDyenh2hqgSO9sNt1MrHSdaxffJsCDVklYRf0IZWGkyFyeX2aeK0JiZ90dXYFkoj5YaK2PMmEyPVTkgLf8qWioByAU8pBWRSzQ9WJrjXwi2RTUyR6keOSBRrv4JsZTLFItQA9ZcFSNUk/4swWmaPYzVO3j9FjzQui13C/DLJSzJFAev6HQoGgPKo92Q61n9F0NK+MfGDwypI7Lg3EqHpRhjOyFs8zJrM6BuA7rqsX5HnaS6EKRPuKghwTUQuvHCJ6VRZ6+vmciGKVQZF+mDY+dg0FcsslTtOiR3R9Qck8xmQfkJZVE+9DW5TAa7XINC87vhqp1vDQPf5MP6x4mxtHKvr3nmupUpzHcOYldGVFUL20/LZ/NrIHGX0QRW27iSmLM2uWsEWBlxh/QsFp5W2hK6s+vbxy+CL5yya1f48Dpf9zFxccf++udS4tLxtOjJNTN2T/SYw3WW0vcwcb18AR9FFGk0x6PNQqDHN3IZ3T3raTejBfXMBxyoCnyZG5Y1iV6JzRrLSG9Y33xH/tZ1adzOqNiI3oJT+griHMffGKb7gtv2RQmpkTCf4g9folCiwcLgi4+7rT7ea+
 O3o//EnV
 JHqV4YLhlNzN6jOPdrb5IM9N53tByPqER/Z+h6gKiqMgTu9bbKBEewPcHNJGING/GfDTxBHOlXM5pOV10Etp30uBUbyY9YEfflPKQBh9xtZd+ueVC+ZJqtNdKE8pVUOSnSfMLnNfqPIeEJ8lIYZA399SFG0nM+yvIQAJGCi74Jp8YLxwQcaeFDP+KhZjAbotRv8ylef9n+3d4PrsQdsua5hlWLjmDnIXyuXC5Q0dU/v+xryN2scOX/ha0O1Sdw5ywOUBXtWtO3u8SmF42ccGk96f6I/PMVxxHptzfIp6hKeirrhOw5PuPchmwxbj6FA/EjPDJd4KeIWzM0cROpGORZeygPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 02:34:29PM +0200, Thorsten Blum wrote:
> Move offset_in_page() out of linux/mm.h so users that only need page
> offset calculations can include this lightweight header instead of
> pulling in all of linux/mm.h.

Yep, the whole mm.h is rarely used in the cases where this and a new one
(next patch) are being (going to be) used.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

(Do we need to update MAINTAINERS / Documentation parts anywhere?)

-- 
With Best Regards,
Andy Shevchenko



