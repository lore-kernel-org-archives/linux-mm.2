Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3612CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF2B6B0088; Thu, 18 Jun 2026 14:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7046B008A; Thu, 18 Jun 2026 14:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5666B008C; Thu, 18 Jun 2026 14:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7366B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:53:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1215E1A022E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:53:44 +0000 (UTC)
X-FDA: 84893932368.06.6B4BE3B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 314141C000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:53:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CVKmec6l;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781808822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEutp4IRjVrS3ezV1l+pppFWYqOeurv/p1BhcpFupUw=;
	b=paI7yo8w6Wj71kBygAsKTIvqKpvjbzjfiApFfE9OT6jWYJxTpgp/elGpdn7u+aZlyvYk6T
	2zcyFo28YUa5T6TtCA9dygoc1vfgTy0JG6ff4IgNxP3ozy1ncUuB0O3vDFVBx2ukL76k2s
	yXkqskNT0P1XAPhHuCF669IU4ZISBSo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CVKmec6l;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781808822;
	b=LvstJ6FwZgXxy2N3xlQk1vKOoL7DNgSESPdsMlnMBEe9w3/d0js0noc6ti5m1+zqLig5Vh
	vib16aDau4ngBfB9i8kZCA6twbuAwdyL7DheBn0SHh5fv4saz7ulGVG54gfpgK+k2LgG2v
	SAaVgfTbWeBG/zcy+TzL4rHuU3LWitU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781808821; x=1813344821;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WTMcBDrEIruyGmLf6GVfkeHewD6PmQp5b403W9sr9wo=;
  b=CVKmec6lnH20g4sIYHL/9nlzaDIlviEwPahi3WKHi1gLC0gAu6IuZyGr
   S8GTlL90+aEvQlIkuNUJzG6/sHq1m/tC/UoPnlH66PVPHUEDy9XiulblO
   mEmmQXapyZkf19TtwKwedJGiWSvMOHvz5SHzGfd3Q1Wm0rVAsSdxbLVlm
   dKByFzZC8g1d0eqz0KORowu+p3jQ2YByIZmYfBwWR4L+PlNIDA65iKbmC
   wB6i3v/lUD7FQ6XdRyVVa+Yp3oLnx6+oHgDlnrQfIOR9ufEqZ5PJSqu1z
   zL5BRGx36GaIaELG8LV5khEATU6QkR2MjA4ioVKcwuDkPs5YoeaAuP8ME
   Q==;
X-CSE-ConnectionGUID: y6Cf8RAnQUuMJA/qbET4WQ==
X-CSE-MsgGUID: mFjd67GSRyODZ7blGfYvdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="81643753"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="81643753"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 11:53:39 -0700
X-CSE-ConnectionGUID: mI/Woks2Qd2vgyNclGX5ww==
X-CSE-MsgGUID: 7CCmnwTHS2G+l4jB6Nv8CA==
X-ExtLoop1: 1
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.222]) ([10.125.111.222])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 11:53:37 -0700
Message-ID: <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
Date: Thu, 18 Jun 2026 11:53:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Zach O'Keefe <zokeefe@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 314141C000B
X-Stat-Signature: aa8unt7dnz8umbo3oy7kgagabni39nzb
X-HE-Tag: 1781808820-679463
X-HE-Meta: U2FsdGVkX18Jh7cEmzxfNVvH/GbL8FO4s5jHiE5wUBdYfT3UCZofNSRlWPWknqzBYzp3JcFWgGViM/Cye/TtpdTF5j4F0pF+sWk3cRGnSinzMnPmpHBnghCMWcfLBH5rPQoRAnfOtbOCHaiy0sq6qzTQTyGfRDRjGlLypyZPjBp2DKWjzvVq7guSzZnJ2MZIofp2rZbP6na6ZwDgHJDyz7B5/dvwMcf8U8HVA86SnHR3ND/1KSzjd9+S7A4CA88MYNmgWzFMt/uiGjdug5P1dOq6Xk7g8+Qt+2vBNM5ipRDkX6hJ43KfoPQ2fM5VRzaQ2GEepBwUabni11WbosL3ErmkW2RQCaO0Zw0MHTn7GABfaWNl9/XjUjtJU+zDUGF7MV5tiWx9CN1yhWX4u3SasPYZdre43vM16JgiDETjWvXbSBdqzthJRhmj0BX6BFFqV5L3sfMza9G2nnkBOsPUC1s9fINMjGpbVpsV4kOR9OtUfn4qT0kgQwAALkuTniZg4Wy9ywIr1La+CXEAKp1olB9VzzlJLnWkedd+CcyFU4MBX3ztMYiduOofGQkM31AvHuEvXVQQ1h0xb+8QZZd5cSostf8fnSBwBQtEtWU++IThi8SLUZFu8fopAv4hSnkg9YdCHiJexHlM+/DPAEgzl/NocMZMWvO2H926sUxL1PZ+yHGzbr3PGrRlVzti5UmY61UD3axE56iAa4wLbLxuhhAXmf9R6VOAWWkCFBKkwQvAAkDX3CbzrnsuPEt3SIKnu9sCi8LUcdCTjGs56rfc4ILAukQcUL0PT/zhd1ROYj7oULC+qDA99VrWka032w5Qo1sm7GOkOeQEpxXoZLwwxqAdzV0SK/+htd1grtl4v9/7Z4kFi0GHdXu4hXSra0hbFtrNmlAMQRyrmQQ4jRSMvwAZyVvXqwMX2ItqBd/ys6KsRSnq4Wu1mu/jiqJK0U9TUWB4RBHbrXkQLu7US6k
 eRqMOLsx
 WgMF+J71caMktgBM1rVnvMoLCgUEH6xworNbRbqBixGPeYoguUAVgTzdUuN+eK8KWBlSqh5BTAVrFcrAj9Y987XFH7icr/U7jU75W8qlfFJNpw3GTpTYF1ddwrjglf8fprwOTuNseBRPXn9C4RLT9k+ik2Cvye/0+Ka08kFxelIyhjR1c2dII2ri6+M6o4Mz6LksuzkY/KLj5jhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 07:50, Zach O'Keefe wrote:
> Overall, are there any particular painpoints you'd like to see flushed
> out, first? 

Handing exceptions in the kernel is hard. Period. That's the pain point.
Just look at NMIs, #VC, #MC and the rest of that mess. Just look at how
we've moved away from ever taking random page faults in the kernel. Or,
heck, randomly taking faults at *all*. We've concentrated them in very
specific places, not in general code.

Now you're arguing that the kernel can pretty much take a fault *AND*
allocate memory reliably at any point*.

I just don't see the collateral in this series to justify that claim.

The NMI entry code is a disaster because NMIs can happen anywhere. The
#VC code is a disaster because #VCs can happen anywhere. Once #PF can
happen anywhere*, why won't #PF become a disaster?

It would be a completely different story if there was a track record of
finding and fixing bugs in the x86 entry code from the authors of this
series. But I don't think I've ever seen a single email from your folks
before this, much less a review tag or a patch. I'd be much happier if
you got Andy L's blessing on this, for example.

> How would you like to proceed? Would explicitly marking this as an
> experimental config, in the interim, be more attractive?
No.

The enemy here is complexity. *Maintenance* complexity. Being able to
compile out some of the complexity helps with debugging. But it doesn't
help maintaining the code.

--

* #PF on stack accesses isn't *quite* as bad as NMI or #VC, I'll give
  you that. But it's still pretty darn bad.

