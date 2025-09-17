Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACA0CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C6E28000E; Wed, 17 Sep 2025 14:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BE3280002; Wed, 17 Sep 2025 14:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7046828000E; Wed, 17 Sep 2025 14:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A957280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:43:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEAC9C062C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:42:59 +0000 (UTC)
X-FDA: 83899614078.13.0E05AA7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2BF6540003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:42:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=31NPyURf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+0O3GflI;
	spf=pass (imf27.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758134578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgxBzCQCDvwwT1MdtXjPWMiw/X9+NdfomOMbxA0z+nk=;
	b=XRqw8lDnf9CH2SYyAPS1L/7Xg8alWCVUk9QyJE/+vI2wbvmZgFXfjP66BGkd7vIFCteO/N
	EzQzoXMvYYFDQwkX9kt8rzzr8UBfJCcZLtKASdkXi1OWZZ/6QSe03WPA+lQOKlD7A0TOK/
	i4BiOK/NtA+E5hJ5WiDVqJVSMWdm4lQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=31NPyURf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=+0O3GflI;
	spf=pass (imf27.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758134578; a=rsa-sha256;
	cv=none;
	b=FkCOczYi1xqKbWL0X8N2M28Esu2GccR9yt4l6PxfpFElTJI117brHwi7MowzbL8YUIyJOd
	xj1Rq1m7pyLjv0GU6IWLDfAERsTgYwutRKZ7dt4Pii2LvhxWJ5ggpu+iYZUNRmX9xwkx8L
	0mBtUVzSlAPmmiBmYciBSvDLx28Ny5c=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758134575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgxBzCQCDvwwT1MdtXjPWMiw/X9+NdfomOMbxA0z+nk=;
	b=31NPyURfNoC+Hp4DlCfka73PQbGe2AnSx5Lhwo3ZAk40OESvmsNtKLZX/mLN+gUMrsQ7Xj
	oE1AJTAEi+EfVNjcJpgdtsMX+9eZeJVcd9Cxf9O9hoWMReNGVFq3KDq4HwFLvTJyTvpG0q
	5tVYyYZKYPYmlYS1v+blGf4H505UHNUxr/5ykB0Z0b+1B0qOtFt2rLmkRPEIqCIw7dJu+t
	CZNMJy4quCw5wPcBPT/ZONfgr9blUyWN2Tu7MkrKyaD2A2Bjm6turlQT2tLG4ftXi6KyEr
	8wZRxR70OE05sJ5qLeKfeX3NfNnOjt+EX11TDmw61wq3ERRuxc6UzjUz9nzxiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758134575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgxBzCQCDvwwT1MdtXjPWMiw/X9+NdfomOMbxA0z+nk=;
	b=+0O3GflIeWtQKvcZ+4RGDE9CFHto6HOBWzA3hxU9BVVK3FujuWCVujUHWubIAY5CX/ouK9
	VWtYg60SdwLM0iCw==
To: David Hildenbrand <david@redhat.com>, Eugen Hristev
 <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
In-Reply-To: <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com>
Date: Wed, 17 Sep 2025 20:42:54 +0200
Message-ID: <87segk9az5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BF6540003
X-Stat-Signature: 4ya59h5f8nwnkhy68ecwcixisi9b5fme
X-HE-Tag: 1758134577-356521
X-HE-Meta: U2FsdGVkX1/ILSrfAg62uYFgzRctAWhjmpzNHWKpyiLCyCQOIhcDm/JEbm0Gu4kInqdxQHJ4u90i7M50M7s/yAH8a9d60qatQIVkxpvikDDnbHXF0rfjRLvVdrOJZvZBzaOuTVdZ2AvNLC5J+hWlbO4J/uDEDpfpJT74z2er4HfOxNJLxulLIdcvcHpH/JuwDZfU29nOOrdNWN9rwWgdUOJJNS5FEURtfn31FHs+kZW4Zibq9hNzMaxgJNOZHpEDhVW4TUv9VEHo0GJ9cJwvdYznaqzt+ghBy0T8tRZDG4mUV9YbTw1FnmsGjuAATKPi+hmVjM6SZKYe6SS2ZBEy59wH+KhOlhcaBZJ+dXlsKPLZRxAZ/B1Ehe02FYoDpUw8W6sJyuuYq0Bo05xVH9QfV+eta+eHXF4Izc3mGIyth6ktT7muZDAX1qk33tYYYEsk4jDblDReZiXAEtpecbMBzPaI31HPIAquv+TFpsY+sk1qi6u3J2xBohN+KBc1EMIVJVn8oMhoXLVb0lcWeKGsYgQ3+FmaYVvlztDoV1Hoe3GPBFMtrFVgCokxeABDroemdx1EQEAwo8HRVZ45R9emVzRpAZ9vJ8o2dh8+wQgAsp6nsNQ872Ea+pvH2Geqkp1PWJMsD6Vuh5/99WuyHix7Ewh6WSXf9Z455XPpBk69y0cvrIlUfuVFUK74ZrsOMj6luQFuWJ7fvtwXxPzh2xOrD132j8fhh7eK5enJIyt6azoEW4o9CO9U5yLUOqJxrNahcxkPu3MXy3y6q/GiDogLYQ64QC4RSlgAEzBgLY7n02kPXlzJGLV/WtgjLazGMm8LXbwukTVjocO37oSZl+75dG6ClxXaV1WquJJqQYZlkxnD5DZu346ztzaD7S/ZCm0QLz+6zDpFy4oVGTmzRFnVCKlwhyHeQxK3yEhzFy5qF4FWRLQMsw2vlTuX+OY/3qB3hw6o4MioxjVnrZbKmNO
 CarJEYIM
 8wy3NUYpeyfE7Kw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025 at 17:18, David Hildenbrand wrote:
> On 17.09.25 17:02, Eugen Hristev wrote:
>> On 9/17/25 17:46, David Hildenbrand wrote:
>>> On 17.09.25 16:10, Thomas Gleixner wrote:
>>>> Sorry. I was busy with other stuff and did not pay attention to that
>>>> discussion.
>>>
>>> I understand, I'm busy with too much stuff such that sometimes it might
>>> be good to interrupt me earlier: "David, nooo, you're all wrong"

I know that feeling.

>> The idea was to make "kmemdump" exactly this generic way to tag/describe
>> the memory.
>
> That's probably where I got lost, after reading the cover letter 
> assuming that this is primarily to program kmemdump backends, which I 
> understood to just special hw/firmware areas, whereby kinfo acts as a 
> filter.
>
>> If we would call it differently , simply dump , would it be better ?
>> e.g. include linux/dump.h
>> and then DUMP(var, size) ?
>> 
>> could we call it maybe MARK ? or TAG ?
>> TAG_MEM(area, size)
>
> I'm wondering whether there could be any other user for this kind of 
> information.
>
> Like R/O access in a debug kernel to these areas, exporting the 
> ranges/names + easy read access to content through debugfs or something.
>
> Guess that partially falls under the "dump" category.

I'd rather call it inspection.

> Including that information in a vmcore info would probably allow to 
> quickly extract some information even without the debug symbols around 
> (I run into that every now and then).

Correct.

>> this would go to a separate section called .tagged_memory.

That'd be confusing vs. actual memory tags, no?
 
> Maybe just "tagged_memory.h" or sth. like that? I'm bad at naming, so I 
> would let others make better suggestions.

inspect.h :)

I'm going to use 'inspect' as prefix for the thoughts below, but that's
obviously subject to s/inspect/$BETTERNAME/g :)

>> Then anyone can walk through the section and collect the data.
>> 
>> I am just coming up with ideas here.
>> Could it be even part of mm.h instead of having a new header perhaps ?
>> Then we won't need to include one more.
>
> I don't really have something against a new include, just not one that 
> sounded like a very specific subsystem, not something more generic.

Right. We really don't want to have five different mechanisms for five
infrastructures which all allow to inspect kernel memory (life or
dead) in one way or the other. The difference between them is mostly:

   - Which subset of the information they expose for inspection

   - The actual exposure mechanism: crash dump, firmware storage,
     run-time snapshots in a filesystem, ....

Having one shared core infrastructure to expose data to those mechanisms
makes everyones life simpler.

That obviously needs to collect the superset of data, but that's just a
bit more memory consumed. That's arguably significantly smaller than
supporting a zoo of mechanisms to register data for different
infrastructures.

I'm quite sure that at least a substantial amount of the required
information can be collected at compile time in special section
tables. The rest can be collected in runtime tables, which have the same
format as the compile time section tables to avoid separate parsers.

Let me just float some ideas here, how that might look like. It might be
completely inpractical, but then it might be at least fodder for
thoughts.

As this is specific for the compiled kernel version you can define an
extensible struct format for the table.

struct inspect_entry {
	unsigned long	properties;
        unsigned int	type;
        unsigned int	id;
        const char	name[$MAX_NAME_LEN];
	unsigned long	address;
        unsigned long	length;
        ....
};

@type
       refers either to a table with type information, which describes
       the struct in some way or just generate a detached compile time
       description.

@id
       a unique id created at compile time or via registration at
       runtime. Might not be required

@name:
       Name of the memory region. That might go into a separate table
       which is referenced by @id, but that's up for debate.

@address:
@length:
       obvious :)

...
        Whatever a particular consumer might require

@properties:

        A "bitfield", which allows to mark this entry as (in)valid for a
        particular consumer.

        That obviously requires to modify these properties when the
        requirements of a consumer change, new consumers arrive or new
        producers are added, but I think it's easier to do that at the
        producer side than maintaining filters on all consumer ends
        forever.

Though I might be wrong as usual. IOW this needs some thoughts. :)

The interesting engineering challenge with such a scheme is to come up
with a annotation mechanism which is extensible.

     Runtime is trivial as it just needs to fill in the new field in the
     datastructure and all other runtime users have that zero
     initialized automatically, if you get the mechanism correct in the
     first place. Think in templates :)

     Compile time is a bit more effort, but that should be solvable with
     key/value pairs.

     Don't even waste a thought about creating the final tables and
     sections in macro magic. All the annotation macros have to do is to
     emit the pairs in a structured way into discardable sections.

     Those section are then converted in post processing into the actual
     section table formats and added to the kernel image. Not a
     spectacular new concept. The kernel build does this already today.

     Just keep the compile time annotation macro magic simple and
     stupid. It can waste 10k per entry at compile time and then let
     postprocessing worry about downsizing and consolidation. Nothing to
     see here :)

Hope that helps.

Thanks,

        tglx

