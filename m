Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6460CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 19:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707F06B0005; Sat, 20 Jun 2026 15:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8246B008A; Sat, 20 Jun 2026 15:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581366B008C; Sat, 20 Jun 2026 15:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29A6F6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 15:45:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D84CC14B7
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:45:04 +0000 (UTC)
X-FDA: 84901319328.22.4E4D255
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id F081E100002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:45:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=U+QJTToy;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781984702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh93y9QYeEKYaxcfZCFWA2VWHbjvj1JFAamA5gqPidc=;
	b=mRgiFShdE4JO0VQeBEm2WNu9IwxAUYHEJarz/NPQQENaNjXGW+O9imblBIExH7xhLwvwA2
	qrSxVd0iB85kr35xvkVzvtUa9qt2lrBaYpIbhkoecxXIf69sF4YNoJHcjg6MFyAB19L6gD
	750TWj3BLyYK8QoPcaOPPv1qi14usYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781984702;
	b=I6r9PT6AgW61T/EPQSRVdpQ8h1TQY1qdOcrlGRHD4qF32aQY5ZtLlbVUHFUFywEBJk6kre
	+5SG1/Q1AqJw/lTViQc9rSthXKQSicst52HjgBaI1bNfog2TnaKpirnwjk04jrlz4WT3if
	XvS7GK6ML8tZehO3xrq76sHrdqgAMCg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026052701 header.b=U+QJTToy;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65KJiRpM4043891
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sat, 20 Jun 2026 12:44:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65KJiRpM4043891
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1781984669;
	bh=Eh93y9QYeEKYaxcfZCFWA2VWHbjvj1JFAamA5gqPidc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=U+QJTToySHC7PwugsabxiEHP3EyjE6Z2LC8IA5sHlAXpdvWENtT7kHZ4D8iJN4ESU
	 fRKFaFAZpAs+U3C8aHpfoFwZzfCFPSf/3sAAVkSAn6W8KsUFVLMjHgxPNyI3aHLOsG
	 a17BAUt3Ixm46XTRSRtAVpOBEQ90PGaPziHCadUaSINjrvZLH8Q93bbZ5oDfN9AMKE
	 hnxE5Lm+v7HZ5oLpVG8Dw1XkZMkQRpMMOcr64EaTeiJv9P4m8b37kHS/R44/fLzrm6
	 nZk1mJunUSIkVhjwfIAbCpnTFzAlgf0typda9rZFlHkqak5O1TRdMPrD/wGw6nlHlD
	 gqisJ+OeHjJLw==
Date: Sat, 20 Jun 2026 12:44:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Zach O'Keefe" <zokeefe@google.com>, Thomas Gleixner <tglx@kernel.org>
CC: Dave Hansen <dave.hansen@intel.com>, David Stevens <stevensd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
User-Agent: K-9 Mail for Android
In-Reply-To: <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com> <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com> <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com> <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13> <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com> <87qzm2b39k.ffs@fw13> <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
Message-ID: <A886B02F-537E-421F-997A-26001F91295A@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F081E100002
X-Rspam-User: 
X-Stat-Signature: s39e1oi65kr9s5nxwtcot7yu7ho71w5g
X-HE-Tag: 1781984701-279975
X-HE-Meta: U2FsdGVkX18W4R+VoV7Wh32aMgC2PTa2JUtaxno4AWVs5ZJXAthqyyALxFowcQzdl9uVEwRzxfaBxXVZ6ESp9JZZsjkr5RkAcONPzyUDwKPy2FIm6MJ1MqEjtyXdPZMEMjFZyCebiPc6mulzNCiWbjbtNukmLyO6OWgN6leYWJBn+Ayva61QRBwePqrkp54Z0cz+nFIORwGFMURUY8OiI6vZKNhLAKuxx4cqf6pUux82WjGWdAU3p1ZI2ePoBLKITvTiR+355wS+EIMl+rrxwJNzAdgKmd9XIVh7L5bc8I2pj9t6YigFxvtSks/SDtWQhEHNrjBWlj6sy2L0+oXdSD9vPyiuDdi/mpcz4yIjulr0J8QmFAT8L/IbXxugKTYVZhI11TRe3DxED3MBaF30MnjmXiTK/vdaWVrcPyMG2oq25jjDd5OqoilqrBNwnzbJJ6u734AM2QekzXuOk5kDVKbbBeTwE+D9dZD1zuKuAZ+MN/dZzL1cI8s/4deGijuw7PjKDW8Noce7YYvihTzamDWjxxOFCN3tvW5yCMzRuEL2UwoFiIJYY8TAEzFDg8n1CtUpKH54I4Ze2qVt9Vke1MIUVdkiMQxYvRorNvc/KXf0BHQXwOWBFgY9oFl1tAKPQxmUo6D9WwuNC8O4nG7ljvPIokKZGfKhxvsGNpw+OoRyesoxv/ATB+ChZHbijd/SfK6w7qM7ZF8ehi25/487UdI3b4dzP57UeHJZ1misvhI1d8VpoVbMNQoYzNMu2LszoO7fZ/Pd1AabMaKceAZvvFc1Atmo05CJKG2q4vuF7HFv2bidlhFDVwGaoc6FIfkOJNXRUqYhdy6A/6bmEJ8lz88afAxc8yKB0kXVqto7D6VkDGoJojpgKgjVIABnZS4r3X6GmwwSfjS7Q7+aB1CIsrDyRmOz1fKPZrcCsPQDXSLvJs8ph2CYsc7aE9GTrCWN8B9dEbgtK2c67t+eMJj
 QT7i2Yv8
 sdkENddp7zvBXa3TX22hPbQMhFxuZdnYiyxCfv2heyu9H14hK5nye4LbJzOTN8zo6Qa4qsOmCucul2C/OQwDjgtK4KxTv7Bajd/xtvAsF2jDS42uyzPZkPQES3khGKXI4wTu5raYEA3kii+5dXWGYJnGk7XYqrIi1VnThU4TVTKJKh6Xvs0XaOzZlwsUscB7TKkzVG2w4Npaf0TyOGjOYkS4VDv0SEo1OEaUx5f5bSLHBSVQT2J5FOpv8JbQ/kOWr1ribIRIR2shGYjRrYIi5+Q4904unNsnyJLCwO86ckZCcHRS4hUOSRKB1EWtcUqtMEsj2+O4lC7PbFuLluIRqZDINEOTYCtbEK84U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On June 20, 2026 12:33:35 PM PDT, Zach O'Keefe <zokeefe@google=2Ecom> wrote=
:
>On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel=2Eor=
g> wrote:
>
>Thomas, thanks again for taking the time to look into this and help out=
=2E
>
>> Zach!
>>
>> On Fri, Jun 19 2026 at 12:20, Zach O'Keefe wrote:
>> > While it seems common opinion that the IST-based solution is fragile,
>> > what of FRED? It seems like this is exactly the kind of support neede=
d
>> > to avoid some of the aforementioned sw "mess" in various x86 exceptio=
n
>> > handling paths=2E I agree that it's less-than-ideal that we are force=
d
>> > to downgrade exception levels in the common #PF case, but is that an
>> > unsurmountable problem? Pardon my ignorance=2E
>>
>> The #PF path is considered perfomance critical=2E But how much the
>> downgrade matters needs actual numbers to analyze under various workloa=
d
>> scenarios=2E
>
>Ya, that's my concern as well, as I don't have a good intuition for
>how perf critical kernel #PF is for real workloads=2E If this is your
>primary concern, I'll take that as a _good_ thing ; i=2Ee=2E there's
>nothing architecturally stopping us from doing this downgrade safely=2E
>We'll still need the analysis, but that can be a later stage -- we're
>more than happy to get this data for all=2E
>
>> I've not seen numbers to that effect anywhere=2E The only numbers provi=
ded
>> are marketing material about the memory savings on a freshly booted idl=
e
>> machine=2E There are _zero_ numbers about the actual real world savings=
,
>> but claims about the PETABYTE savings possible=2E
>>
>> Seriously?
>
>This is actually the most understood aspect=2E With O(100B) active tasks
>fleetwide at any point, it only takes an average savings of O(10KiB)
>per task to get to 1PiB=2E At least for our fleet, we know the % of
>tasks that use only 4KiB, 8KiB, or require the full 16KiB, and the
>math confirms that we expect O(PiB) aggregate savings=2E The % of stacks
>requiring the full 16KiB is minuscule, but it still occurs at a rate
>higher than what we can tolerate for SO panics=2E Given the vast
>majority of stacks never exceed the first 4KiB, this enables the
>significant opportunity=2E
>
>> > Lastly, I just want to clarify what folks have meant by "extraordinar=
y
>> > claims" or "evidence"=2E  Aside from the above discussion on FRED
>> > exception handling, the "only" other part of this is the allocation=
=2E
>>
>> Clearly anything which is explained with "shouldn't happen" and
>> "unlikely"=2E At cloud scale nothing is unlikely anymore=2E That's simp=
ly the
>> reality of statistical math=2E
>>
>> As I pointed out before the same applies to the unexplained
>> upgrade/downgrade game with external interrupts=2E Such issues cannot b=
e
>> papered over without understanding the root cause as from decades long
>> experience they come inevitably back some time down the road=2E Cloud
>> scale even guarantees that=2E
>>
>> > Are people concerned about memory unavailability, deadlocking-type
>> > issues, or something else? We have considerable design freedom here t=
o
>> > avoid certain classes of unreliability, but=E2=80=94barring any cleve=
r
>> > tricks=E2=80=94I don't know if the allocation can be guaranteed to su=
cceed in
>> > all conceivable circumstances=2E I want to ensure that reality does n=
ot
>> > present a hard blocker=2E
>>
>> First of all the failure scenario has to be clearly defined=2E
>>
>> Right now, if I'm reading the patches correctly this simply can end up
>> killing the wrong tasks/processes just because an OOM situation results
>> in a depletion of the per CPU cache and the very wrong task which runs
>> into the deep call stack situation ends up in the creek without a paddl=
e=2E
>>
>> Given that you even fail to abort a CPU bringup when the allocation of
>> the per CPU stack page cache fails, makes it pretty clear that there ha=
s
>> been spent exactly zero thoughts about this problem=2E
>>
>> Why the heck does this cache refill call have to be unconditionally in
>> __schedule() where preemption is disabled and therefore GFP_ATOMIC
>> is mandatory? I know "Works for me" (most of the time)=2E
>>
>> And just because I was looking at the patch in question I found this
>> other insanity:
>>
>> > +     /*
>> > +      * Most likely we faulted in the page right next to the last ma=
pped
>> > +      * page in the stack, however, it is possible (but very unlikel=
y) that
>> > +      * the faulted page is actually skips some pages in the stack=
=2E Make sure
>> > +      * we do not create  more than one holes in the stack, and map =
every
>> > +      * page between the current fault  address and the last page th=
at is
>> > +      * mapped in the stack=2E
>> > +      */
>>
>> Can anyone with a sane mind and the most minimal understanding of the
>> kernel's inner working explain to me how the kernel can skip "some
>> pages" on the stack?
>>
>> If the kernel skips a whole page or more then there is a serious bug
>> somewhere=2E I might be missing something, but again the "very unlikely=
"
>> wording which handwaves about it is just disgustingly useless=2E
>>
>> I disagree with Dave on the RFC status of this series=2E It's not even
>> close to RFC, it's at PoC status=2E
>
>Absolutely understood=2E I'm more interested in constructively working
>together (as we can see, we'll need your help) to figure out how the
>x86 experts want to approach this vs discussing _this_ series=2E Perhaps
>it was my mistake to necro this thread instead of starting a new,
>general discussion=2E Appologies=2E
>
>To that end, how would you like to proceed? You may understand the x86
>complexities better than anyone, so hopefully you can guide this in
>the right direction=2E How would you like us to approach this?
>
>Thanks again for your time, help, and support,
>Zach
>
>
>> Thanks,
>>
>>         tglx
>>
>>
>>
>>
>>
>>
>>
>

1 PiB for a fleet only makes sense in the context of the size of that flee=
t=2E=20

But it's more than that=2E=20

You WILL slow down the general case by this stuff, and so how much actual =
gain does this imply? What is the mark needed to even get to a break-even p=
oint?=20

To be honest, this and the multikernel proposal are the worst motivated ma=
ssive changes for no demonstrated value I have seen in a very, very long ti=
me=2E


