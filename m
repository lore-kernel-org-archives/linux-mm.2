Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454E7CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1188E6B0088; Fri, 19 Jun 2026 08:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C95C6B008A; Fri, 19 Jun 2026 08:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED58B6B008C; Fri, 19 Jun 2026 08:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79C06B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:45:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4084A4040E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:45:38 +0000 (UTC)
X-FDA: 84896633556.30.A6C01CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83781180006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:45:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crEsyyb4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781873136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/Vhz6lOiktHFsg9eoV4+oceyN6BbtxBaibjZtdCVyw=;
	b=6e2NwViY38QBXBogZAHi77YzFHWTCp1VTltU81/BsVO0OkwfDoT5/+RxbzEVj3gvHDPj2E
	pMhoTaHgw3DiyGO3PhObDMfUGWoYZa8opF+p+FG079D2Ujbh1Bfu0T33gY9Tx1uaiLuhiX
	M+3Vy3C5drb0rz1WywlZGBVIjtpC6jY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crEsyyb4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781873136;
	b=fijOXLQ1KAVg4G5mrws1/5ZhZFeLMAxOxDroNMve17e0Me6W9P1WgusJhJkHrPK4MiLmb6
	96KfGztaME+IsLE4BEo0L9/7XLWOUoe+C54aDSnnCkgUFw+/UlKRSPv5xT7HYAs6xZlw2g
	2Y0Ti59fg8S6mWdHovVZthmt4RCKDac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B22D40A6F;
	Fri, 19 Jun 2026 12:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAF11F000E9;
	Fri, 19 Jun 2026 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781873135;
	bh=L/Vhz6lOiktHFsg9eoV4+oceyN6BbtxBaibjZtdCVyw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=crEsyyb4DPjpSRuGTlnWJ6/ztzR5JnGP9C/rROgh6jlFUllrBxDQaANCr39K6zTUj
	 EZfZwtqBaGCBJULOoxGCl1ETc8HjbrAF+JiwmihwwpJR+BytRx67bASip+9cQXTCnm
	 sov7vDyQt1oPjLb7Cv9yNPU22Slw/QYIPuFeRszoLlYXHhm9ydbpCzAUNOEXKM/L52
	 erekEPdF5PNV7UIX2U/C2JG+gZHJC9X3PSCEuriwiircCaLfXK6/yv08OW8PjeBqoI
	 IRpGFPDuEXq2pqW8LskhzGF4c7AIL06/SBdNhAl+dzhvANvoek/MLugG8Zru8ytbEK
	 O1Lkp9ddMZgpg==
From: Thomas Gleixner <tglx@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>, Zach O'Keefe <zokeefe@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij
 <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, Quentin
 Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
In-Reply-To: <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
Date: Fri, 19 Jun 2026 14:45:31 +0200
Message-ID: <87pl1md7h0.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83781180006
X-Stat-Signature: 57g1oiqwwmtke55ejo1ytzi18yge3xf5
X-Rspam-User: 
X-HE-Tag: 1781873136-319499
X-HE-Meta: U2FsdGVkX1/unzYYCUXCpgqTStPDM0E1x91VqrwycWky8dOm9rD0qoMD65u2H+7LsSrEO/yi98wMT7wiWTOBg1Sa/GwlaoDoiEPzR+3c0FJr7bXih8z6m9KgbhIcoAobAftuiFNgffCdN4J5uYBFjV6kE3FiNGXvdBhIdmD1rjJRHDdxPEzH2Gccr+Xi9HhyxVq+RiLx62qlGsTUysu4vpH1pQ/5Vi1t8mfm+Pbwbq0KinmQk263YJ6MCvPFA+hsyv8f48HtJSgJkp9Y4wXbPKgca7YAgFgV9SFpdH/b22NhSoESdWqhxWfX8IpLrTBEiN69/+qjB1tbIAcdxhVHNtsEc/8uE/96+IjhDgHceK0gh6ZMQXd5a2wJvwAixsdzujrp5b8GnZKYCRjF4W5tzyBSP5uWdsDzrY1EBeaMthAEeC6hVRADvXtSVyAB9vreD3qw92TLhhpBr4VWJZEu4kmas0qioCtFahhiP6xfveIpBZQhld6yPd4PHei6WsF9OdaluwemZNj0fhHLZcq9NcMMBT4fMCvtVwWldlk3q4J8uVwEgxMjSjdLoS2iK/MrpjCJjCNvNKrXdGui43qtuxQW7sS+KfvevzxBByXo8zX9Ykg2dcRKzf3jgFyfbFKDB5QfDNIvf9d0f4/aDH4rx1QJZr4+YPkQGoGWMzlYmnVUwxRC7VL9zmtlS5CdbGBHhOWE0dkerODXUwqkluMUs2ZjYgfyMRnsvD8dVPNhm2wI67Y0vWf9nTj4D/Xlx+ZEhJTDLwqR9tnhC1xIQlMk2yifT+XNLjMni13R/uSOo/Ch35iN/F0S6rH/5BLm/8kXx/eGxLeZsRJfvb+Tpp5MUjGtH4tEjrJA3DMoWn9S0HWmkpJyk+vlLCkyxxomISq+9J+ieXczdZDSiUpjhYhA8dM8+19ZX0wc5hx5SfDwtJuipAOsNkiTHZ0X7DrKaECIXNK5L3gTA7v12YJIPYZ
 bodajtNj
 CbjvRn9xF+RMT8r/e/xdAt21qjE9Typ4cnKshZpKteHTCO0tSabuyuKXl295xQDYet8OiO4gSUES35+oI3PkhjUclNtb+n6tXM7v7TccZVz1MwHKnrT/OO3jw+x4uI44QqtzjapER9e3K7n8bUTRqkQx9VPXLUPvZzQOPJRI1XMudXoSZ+itxPz3uLdpp5y1xXbK+13/pVnNjDgSwH98VUKco/NRnSN3fhQOFAGNUl4/Kqa4i/F2OPnOX5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18 2026 at 11:53, Dave Hansen wrote:
> On 6/18/26 07:50, Zach O'Keefe wrote:
>> Overall, are there any particular painpoints you'd like to see flushed
>> out, first? 
>
> Handing exceptions in the kernel is hard. Period. That's the pain point.
> Just look at NMIs, #VC, #MC and the rest of that mess. Just look at how
> we've moved away from ever taking random page faults in the kernel. Or,
> heck, randomly taking faults at *all*. We've concentrated them in very
> specific places, not in general code.
>
> Now you're arguing that the kernel can pretty much take a fault *AND*
> allocate memory reliably at any point*.
>
> I just don't see the collateral in this series to justify that claim.

There is none because it's simply impossible to guarantee and when
reading through the series even a CPU hotplug operation happily
continues with success when the stack page cache of the upcoming CPU
can't be filled....

> The NMI entry code is a disaster because NMIs can happen anywhere. The
> #VC code is a disaster because #VCs can happen anywhere. Once #PF can
> happen anywhere*, why won't #PF become a disaster?

It's already a disaster. See kvm_handle_async_pf() and the cute issues
vs. taking a #PF in NMI or some other IST handler.

> It would be a completely different story if there was a track record of
> finding and fixing bugs in the x86 entry code from the authors of this
> series. But I don't think I've ever seen a single email from your folks
> before this, much less a review tag or a patch. I'd be much happier if
> you got Andy L's blessing on this, for example.
>
>> How would you like to proceed? Would explicitly marking this as an
>> experimental config, in the interim, be more attractive?
> No.
>
> The enemy here is complexity. *Maintenance* complexity. Being able to
> compile out some of the complexity helps with debugging. But it doesn't
> help maintaining the code.

Correct.

Aside of that the part which worries me most is the IDT hackery. That's
fragile as hell and full of unvalidated assumptions. Reading "should not
happen" several times in a changelog doesn't make me more confident.

  "It is possible for #MCE to occur on the #PF IST stack, but the #MCE
   handler shouldn't generate new #PFs. The reentrancy check on the #PF
   stack will trigger if any recoverable #MCEs do generate #PFs - if there
   are actually reports of it happening, we can address it then."

Seriously?

We don't wait until the report comes in because the report won't even
happen in the worst case:

       #PF on IST
         ...
         cmp    0, reentrance
         jne	abort

       #MC
          ...
          #PF rewinds #PF IST
          cmp   0, reentrance
          jne	abort		<- Not taken because #MC happened before
                                   it could be set.

IST is fundamentally not suitable for this and I'm sure there are more
holes in this.

I haven't looked at the FRED side of affairs yet in detail, but the
handwavy explanation about external interrupts having to be moved to
stack level 1 and unconditionally bounced back does not really make it
appealing. I agree that chapter 8.3.4 in the SDM volume 3 is not really
helpful, but papering over the problem without understanding the root
cause is not cutting it. If it's a genuine FRED hardware issue, then
this needs to be understood and documented.

The x86 folks have spent a lot of time to make the horrific x86
interrupt and exception handling solid and therefore have zero interest
to deal with the fallout of something based on "shouldn't happen"
assumptions. Either it can prove correctness under all circumstances or
not.

I understand the save tons of memory accross a fleet argument, but a
large fleet is also a guarantee to trigger all the "should not happen
and impropable" issues which are gracefully handwaved away. That's a
truly bad tradeoff as it ends up in non-decodable bug reports. What's
worse the have to be handled by the maintainers and not necessarily by
those who implemented it.

Thanks,

        tglx


