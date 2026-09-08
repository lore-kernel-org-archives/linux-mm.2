Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84820C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA2F6B00AB; Tue,  8 Sep 2026 05:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AE06B00AC; Tue,  8 Sep 2026 05:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C116B00AD; Tue,  8 Sep 2026 05:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65E676B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:13:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60C67C04B4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:32 +0000 (UTC)
X-FDA: 85190031864.15.8DBE354
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90692100004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJrfzRRr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858810;
	b=S4ajiDV0KKyUJSmNxwNQluqt+nVTdpKnFZkVwkzYq3ZWq1dTSx12PWFZe5ne36HtP76PME
	wyGUuO1Kk8/t2Pi67h15kr+nTROc1idgY22C1+78jvRLjMG3TlpwLD/NdgbWvh9WATz8DF
	IJxbi16aizk5uioPI0yAyFcWYwb4Dmk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJrfzRRr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gBZLGjrspJ1Thek8jLIwXLFqBkp1PnFICpQVjJ0dMo=;
	b=eUycqlbtuvuRLhgyjiDEzO60PYOCgNDVo8KHnxHVbYCnWe+a80vDCoWJGiwQbVMl91oz9P
	/CYQwaLeuAbHEp0S27wsivbgtMyGcr6HCm/AH0ue2JMXOeEvk/cty9Lx8rDp1izAXQeOCP
	m5fHBbufVXDwo4QqVTML2UETXtGqvnc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAB9843760;
	Tue,  8 Sep 2026 09:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442DF1F00A3A;
	Tue,  8 Sep 2026 09:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858809;
	bh=3gBZLGjrspJ1Thek8jLIwXLFqBkp1PnFICpQVjJ0dMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BJrfzRRrOMtVug6y1PMUNKS9EYpKvtXlh89q6HnndXw7z3TpsOh4ThIWdsDA7HN4Z
	 2wuYJPd3d1WwWLc3K7VN/8j/5H5RmU/L+DE+/cngINT5WhGFiL5nHJyHEEFO4lwP+y
	 bgQAv7wRQlYqOFGsbqyD1Jm6r0H7nOzxBtlfzqa/8I7SvCrZFASUwm6ZcGgLMNaMN/
	 c+0rMlzRYQyKZ/CJXNWwaibhXV7rvL48rhIRpGF4c965usy2qY8G4FNrm/T9typmC5
	 gq2sxrJ9g6RAeYCIv0g6kaS9BfssDSnCvXXn0mMnkzstRIyn2DbmtQuEiwdsD1JxMq
	 HuO9UkKOuIz4g==
Date: Tue, 8 Sep 2026 10:13:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Weijie Yuan <wy@wyuan.org>
Cc: "zhen.ni" <zhen.ni@easystack.cn>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
Message-ID: <ap_P_Pvlpn2rEjBV@gremlin>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
 <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
 <ap-qDThi-NQgVXVD@wyuan.org>
 <048d7470-a813-4252-a4f0-0ec29694f639@easystack.cn>
 <ap-zYt-1qCBGKZed@wyuan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ap-zYt-1qCBGKZed@wyuan.org>
X-Rspam-User: 
X-Stat-Signature: e58koicozisue7baw9tbsfngzgeyw5tw
X-Rspamd-Queue-Id: 90692100004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788858810-932155
X-HE-Meta: U2FsdGVkX1+z39B74a4Cxn2975VvEtHWPTO9OHyOlLh5g/KDyj1qtdes3D8ljfDVUAIXwsjpl3MSMV3rvbctd7l+evWx5moobhx3eilZgPaV3GrXOTJZZfdQgt2Bpuc2Yr22VjcHlIAdxeJKqeuLNVznJ/nVHG688UPzz2H+R900vwtfXvcyW/3tHpSdsgpWCm75u8mdyXOPfAkJ1GCC9vSkHe9JpzGN7DTMxi+ygc3t/eoHO9kaAOVwolMHt4sGSzy0EA7MQEgz51FBRU4lez/kKTKCBGv2TrSMtLIw7mHlfIHxB5+Pk9cbOjHcLYBRI0vph30cfV6Hzdz/pmQqMHCGlJl8wXVDN6WYh+DsrjPPV2JOcF4gTsQmiguihxs9weEHB8wj5CTJLnP5Amf/EinHtDZQAzkWAbcRATIbnBq9fsi5UUVU3YFFe4reKcTcTES5Z5E5NrbRDoCOqI5NYVMxHBhRYIoSTLQ3ST8aqqfUed0bEtXraut41WR8COiSmtMWwD3ranAt6/z/drc4kUpuFlwfY9Y3qI3FkwTbYJoaDiH2n5yynm66+bwsAsJtCYdGv30p2/mt8p0iYYTAyLzIQOLmKShBaQCVKzsNCLb/GunMXUXct8XuwdFHIzUQDMOg7RP6DGBkx1CSegZnAsJ1CLW24WPNZsb3J2SgT0QY0a4TuOvc3DpWPkTCAC1LKQGDE3hopdGUxkRPwyuH+tYOacR1wW9hRMvYWfRfOGlM+LqYfLpFG2O00OtVG6L61sXCyWS8enWdV1nJIJ3N6Yk1O8Eblt5VQtP/1jKzyMDvR1wVGGlLbyKJOZy2gr79Hd0g3d9/iWja7rM5ymnIWJOV9TXXcIzPGqS1izcXL86dJxl00Rq8jhmYkf6HU7krr2/A/6ueB+ijE5sUYfM3cOLsCCnAFpoGjvW8AkYRJ5ONH05Y1zW+VcGXlATGMOWzrh25pUhKxqoDpphZ5+Z
 ehvOLpsO
 ZrxEjfTP93cQy4k7bqCAHpmgtjuRYoE0ZnPTXvAut61dAXKKhY+d+1i6iLd34dWIikaapHw+9txHWLbdHNRrfowQhAZbiL7roVuNU5Zx564mvbWJUMYgSZLwzcr9oIKm+pZs1gS3oProHrz++iLLxTnc9pu50IEtihXHLv9goObo74KSDJZ8MrR5kVkMiSIXkuasE4M0nYjklSvpRj2RqQwfShArIEBwPA5a/+p8HxCAXp/7DwyB1tZcsh6hdFWj7zLEp3hHw5Cl02txA4CtiJ3CWI3U7hVHZQmadIoNShH8fwXIQpVW2iAYE/YEm9Vid1x36FY4G2MBJXRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 03:04:02PM +0800, Weijie Yuan wrote:
> On Tue, Sep 08, 2026 at 02:40:10PM +0800, zhen.ni wrote:
> >
> >
> > 在 2026/9/8 14:24, Weijie Yuan 写道:
> > >  From an outsider..
> > >
> > > On Tue, Sep 08, 2026 at 10:41:23AM +0800, zhen.ni wrote:
> > > > >
> > > > > Sorry but your whole reply reads like a LLM slop. It took a lot of
> > > > > mental effor to actually try and engage with it.
> > > > >
> > > >
> > > > This reply was written by me, and its viewpoints are not simply copied
> > > > directly from an LLM. The LLM only assists with the wording.
> > >
> > > So that's probably the reason. Your previous replies was indeed very
> > > much like the output of an LLM. Even if the idea is your own, after
> > > being "polished" by LLM, it's hard to read. I know English is not our
> > > first language, and it's not that easy to speak like a native speaker.
> > > But may I ask you did you read it before sending them out? I really
> > > found this bunch of overly formal content a little painful to read.
> > >
> > > So I suspect the LLM may have taken too much liberty in polishing your
> > > text, to the point that your replies no longer read like something a
> > > person would naturally write.
> > >
> > > The "Summary and Plan" in your reply in v1, both in its formatting and
> > > wording, looks quite similar to LLM-generated text to me. So I can
> > > understand why Lorenzo asked whether you had used an LLM. Come on, we
> > > all know what LLM writing looks like.
> > >
> > > That said, I do not know exactly how you used the LLM on your original
> > > text, so please forgive me if I have this wrong.
> > >
> > > Thanks.
> > >
> > I really can't distinguish the LLM flavor that clearly in English.
>
> Yes, sometimes I can not as well. But I guess the native ones can.
> So.. ;-)
>
> > I'm sorry for causing some trouble.
>
> That's fine. No need to say sorry.
>
> I know and understand that we non-native speakers would rather not make
> mistakes over these little language detail issues. But over-polishing
> can end up having the opposite effect. Keeping some of your natural
> writing style may actually be what the community prefers, especially
> these AI days.
>
> > My normal reply process is to first describe my ideas, then have the
> > LLM check for logic and grammar issues, and do a round of polishing. I
> > check the final draft once more to see if it has deviated from my
> > ideas, and make corresponding revisions.
>
> Sigh, so it is hard to know where to draw the line. Write more and learn
> more about "human-like" writing, perhaps. :)
>
> Thanks!

Thanks Weijie appreciate your input :) and it's good to get a perspective from a
non-native speaker on this!

Generally I empathise with LLM usage for helping non-native speakers with
English, that's a great use of it, so I don't object to it _in general_ BUT as
Weijie points out there's better ways of using and worse ways of using it.

You have to ensure that your meaning is transmitted properly without it
ultimately becoming essentially a conversation between a reviewer and an LLM.

So the technial discussion you are engaging in MUST be your own.

As for the 'summary' emails - please don't send them at all.

I feel like often they're used to generate a new prompt for the LLM and it
really ends up being 'workslopping', that is, making reviewers do more work
while the LLM takes care of things for you.

And that crosses the line really from 'aid to English' into it being a problem.

Instead, ENGAGE IN CONVERSATION with the reviewer, in line.

So if a review says:

"Please make this function do X, Y, Z".

Don't put something in a summary email or anything like that. REPLY to them,
quoting the request and respond. Like:

	> Please make this function do X, Y, Z.

	OK makes sense about X, Y is a bit tricker because of ... and Z is
	impossible because ....

For instance.

That way it is human-to-human interaction at all times, with maybe the LLM
helping with translation along the way.

As for the review - Vlastimil has raised legitimate technical points so I would
engage with those directly.

It's very reasonable for him to conclude an LLM was used for more than
translation, certainly the rather ludicrious 'document the world in the commit
message' approach looks inhuman.

So engage on the technical points without summary emails, and please put
documentation in a documentation file :)

Also I think it's reasonable now for you to use an:

	Assisted-by: LLM

Tag on this series.

--
Cheers, Lorenzo

