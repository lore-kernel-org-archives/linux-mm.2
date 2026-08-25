Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398B3C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD596B00AB; Tue, 25 Aug 2026 10:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D57D6B00AC; Tue, 25 Aug 2026 10:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411E06B00AD; Tue, 25 Aug 2026 10:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22C946B00AB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:30:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8A4FA2B04
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:30:33 +0000 (UTC)
X-FDA: 85140027546.15.7F2C899
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 068B6160018
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:30:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqIQSfW4;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787668232;
	b=gGyqNO+4JoE/+DtF4zDnJcUyGe/vz2SiljztXcTvTF0efLCllJWqk4fLG+8+X8YgRTjV85
	bzT3B/SFAbgQV2b0mGhuSqbNdMgw95PTqlrr7G1V+6lfiXrPalMwxRZd3hXess7lWC3Sn6
	SHaI5F3gXip7BF+8M44AQgycszHLzJo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqIQSfW4;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787668232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yr6Q4NOR0CavABfY6YlUZG51bL9YNUxR3QoyzBCHjBE=;
	b=FzSZVpk5Iy5SWs2Rsjda5Ih6U2PVOvIt2K4GJeTZysXgUEPnSyh3Ik6O0nalZD+JSKIlJo
	odIOsExzuf3MtitrOkaRfTY+x2A+OsClfSZljdvBUGqj37zH4lWShb82zodnuG8WIbclGL
	g2KYH8Oh7rmAvRh+hWz20lVIKNgakgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B5E16020E;
	Tue, 25 Aug 2026 14:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70D41F000E9;
	Tue, 25 Aug 2026 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787668231;
	bh=Yr6Q4NOR0CavABfY6YlUZG51bL9YNUxR3QoyzBCHjBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NqIQSfW4nswMU0GlvMBIMlbN+WrVl66xLwVU/FiWOSN4Wdei+jAZMtmaNX3XOc/qx
	 zwHocI/XQZLNLbFhmDkuJIm+zYSFa5LHg4N4LDIgkdKcKVgx3CSYFBGEHq/eN9R5UU
	 //18Z4UVKlKqBO6xykZbja8x5N+yFp6GWbbwCuQPEMDeb2qGvaulvysyTovtZoG8MC
	 v9OH/0oF5xLGHP3KhVD8ozUHqfg49GsSIdCWUHUaSSShubIptkQAphjZHnp5eusFck
	 lSlzH5kdJqdHjLN2KSZkyDdnd03SZsT59Ula1uYdwR+scL7pG7YFXtve01sweR/END
	 I4C3WDCr+vcBw==
Date: Tue, 25 Aug 2026 15:30:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Yury Khrustalev <yury.khrustalev@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Message-ID: <ao2mwLHeS0X1aa6q@gremlin>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org>
 <aoRcdLGWaNhUFIPU@lucifer>
 <277db0f6-6161-4ff1-9540-7b1eb5f7924b@kernel.org>
 <aoRto6bT3Fv0jm7k@lucifer>
 <20260819074709.1345730-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819074709.1345730-1-hemanth.selam@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 068B6160018
X-Stat-Signature: m8ckqeq9ei6nwot69ug89n5ki6n8zf8w
X-HE-Tag: 1787668231-921578
X-HE-Meta: U2FsdGVkX1+SKODhzGSOGrRCoWpv8pd9v4vlUUzsg9s2LYevtn6uzG1zb0WdkcVBjT32vbVFa6cOaU9h/xy7X/3jlkMYAxMBlhI9P3Wv4HNQ9Jx4/TipxWklfRXLz3PYs9i2MMgUhPQQCvz+PT016lyDyarx7Nx++6uXJoelnIFyoSxF3shb8+XIWSR62zlacRP152n5fLmH9d+TEjaHBww2EJ3UqUJvuhFSXNxKUn75EvD+xIVjt+IWQ6Ttj99fK3UDtMCKiK9ojW4CNYCurO6Avz0Ts+Cg6JLgf1uSUgbjUkyUfZ5AAHZPbFmDfZ8YssP4gOTjhkguby7bQQpAeYnDuJ35c35Ieb4ifJf9plB3WfTCD9JZzxVA/2gpcNvROlUyj46av+wPxSkNQIVXaWXZPASlPkTs83LPcLqhbydzTt55Ff0Wr7en9jySXtH2KZxS017CWcxy36v70IZqPUXkUmAHq1gbROSwk8uCPuF9FMRYwF52EvfPtqxXWTYHlXI/25RLy6CHX71TgF8pBlQHyv60S1TKEw+umSjWKwOatZgmXsJ5AS8wKobPV5EQo87pVNVRD4+0u4C8njyfv3OMNDjXUONf6h2BhiAqwtL0/iVHn5r5Ec6M67+g9aOq8Pe5Az9zxNRPY8FMxfOsmxYKjYleEAgPtcpLigAf/ISJscQxcKE/+UWfNwEOb4yF7cL2zOeCreJGXnUrNxTO/pO8kcFnlNk3s8pl8FnCV2ljgKFpK/e7ZZO1ppWpAgKpXFX1MIVG6yfeZLaBQ0je/izLfKaBahyqLIquanxUS43BWooXSho7S0w/4pOS5Bfym6yDUhCA6OUc0ZM6Hfw0B3+o2ExvQBBZLoRgGZgjE05U1UtamQ3dAMCpL2W0szeA2G6URAXffanSkZuCnk9JBBP/CHwHqp52QhlE8DVG99H97Ma5i1mpCjP1jySYI2G5G0LRX1B8SJ/mPoJIwdW
 smErHmh7
 LfBWyTp/vIhiGm0saF89eUQuuy3bN1Xbd94juGntBbxK9aj6/uc9tAJxhYiGhnpK8S8wIUF3I6KQG/TOJgZ0YoCv7x6cxqoVE1K/rk1yyUC/roJOu+fJ6LYluYhOInTguEOHGlXYA4L/Scsclkxr5vGx8eKXofCqq3cbaony2f61E963kqnC74LXisRtfMAHmPQGA6GBGmQZO7D8ADscsWnv6nMSabi1H7MDIX+kl+AG8nOlUlltk/DA/+z4R44vJPxFykKfgl2eWLzO8Dg8PYypNTJzeFk3drEpGNdo1jtsVled+p7z0z7qJ/7qMM7CuHqBwryX/M7KXuBgphfiDf+F+hImkw95aghlHb1h6N8gwsVMnYDcpY7OGRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 01:17:09PM +0530, Hemanth Selam wrote:
> On Tue, Aug 18, 2026 at 02:36:00PM +0000, Lorenzo Stoakes (ARM) wrote:
> > But it might be worth checking in this case to see whether the problem here
> > is in fact that we need PKEY_UNRESTRICTED defined over there?
> >
> > Hemanth - could you check please?
>
> Checked.  It is already defined over there:
>
>   tools/include/uapi/asm-generic/mman-common.h:88:#define PKEY_UNRESTRICTED	0x0
>
> and it does reach the mm selftests without "make headers", through
> TOOLS_INCLUDES.  The path is not obvious, so for the record:
>
>   pkey-helpers.h
>     -> <linux/mman.h>           tools/include/uapi/linux/mman.h
>       -> <asm/mman.h>           /usr/include/asm/mman.h
>                                 (tools/include/uapi/asm/mman.h does not exist)
>         -> <asm-generic/mman.h> tools/include/uapi/asm-generic/mman.h
>                                 (-isystem puts it ahead of the system one)
>           -> <asm-generic/mman-common-tools.h>
>             -> <asm-generic/mman-common.h>	PKEY_UNRESTRICTED
>
> I built the pkey tests with KHDR_INCLUDES pointing at an empty directory,
> that is, as if "make headers" had never run.  They build, and cpp -dD
> says:
>
>   defined in: tools/include/uapi/asm-generic/mman-common.h
>
> Pointing TOOLS_INCLUDES at an empty directory as well is what breaks it:
>
>   pkey-helpers.h:188:30: error: 'PKEY_UNRESTRICTED' undeclared
>
> So that is where the definition comes from, and dropping the local
> #ifndef does not depend on "make headers" being run.
>
> The one thing worth being aware of is that the redirection into
> tools/include/uapi only happens because the system <asm/mman.h> includes
> <asm-generic/mman.h>.
>
> I had a look at the history you pointed at, thanks, that was the part I
> had wrong.  If I read it right this is exactly the mechanism from commit
> e076eaca5906 ("selftests: break the dependency upon local header
> files"), which added TOOLS_INCLUDES to the mm selftests so they build
> without "make headers".  So for this particular macro the value comes
> from the in-tree snapshot rather than from whatever the build host has
> installed, which is why it does not vary per system here.
>
> That said, if you would still rather keep the #ifndef as a matter of
> course, I have no objection to dropping the patch, the guard costs
> nothing.  I mainly wanted to answer the question with something
> measured rather than assumed.

Thanks, all I care about is if they build so fine to remove then.

>
> > This is incorrect. We explicitly do not have this requirement in mm selftests,
> > and they're often built without having to do this step and tooling has been
> > provided _explicitly_ to allow for that, which is why this kind of thing exists
> > right now.
>
> You are right, the commit message was wrong on that point.  v2 drops
> that paragraph and describes the above instead.
>
> On the powerpc header David mentioned, I would rather leave
> tools/testing/selftests/powerpc/include/pkeys.h alone.  It is not the
> same construct: it is an unconditional
>
>   #undef PKEY_UNRESTRICTED
>   #define PKEY_UNRESTRICTED	0x0
>
> next to other powerpc specific overrides such as PKEY_DISABLE_EXECUTE
> 0x4, and that header only includes <sys/mman.h>, never <linux/mman.h>.
> A probe including just <sys/mman.h> does not find PKEY_UNRESTRICTED,
> with or without TOOLS_INCLUDES, so the definition there is load bearing
> and removing it would break the build.

Load-bearing :)) Where have I heard that phrasing before...

>
> Thanks,
> Hemanth

--
Cheers, Lorenzo

