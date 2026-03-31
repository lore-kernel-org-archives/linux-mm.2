Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EABEFF60C5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235E46B008C; Tue, 31 Mar 2026 00:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E77C6B0095; Tue, 31 Mar 2026 00:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE236B0096; Tue, 31 Mar 2026 00:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 024706B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:34:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9142AE1123
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:34:46 +0000 (UTC)
X-FDA: 84605092572.13.9CABF88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C869D4000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4rVCzDJ;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774931685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/O+JEctYaw7F0lgevhlP3s9Rk6Nf7MFMhoMgz8AQLa4=;
	b=mjUeqpHku1WhH+jWXMn84D/G80dSQqk4NlIyHm/Nv2Dkb2tbAV+Tnrz0MrfpADxlKowb8i
	Rw5P21IOO2NS/JgfADRGzyUU1o+dhD5hNzTCy0/t+asIS0+VPoRxfCzhPeusc1jHNsAEEE
	bXFZ4M2Rlzq29ky11NhJY6GQ4vCyTlo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4rVCzDJ;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774931685; a=rsa-sha256;
	cv=none;
	b=gGakdcnIUhO4mYJvqWuPmKgH2TLPc8wYmkNsqQdO8gH6+ZBLfY5s/5v+2OR6+ERlSfddzO
	k8NJM/+Y19MTGveyLmJdwYaML1VkYQkVSVWihk0R7dkts78OyesYTXftY66MxAwD/78Qy0
	XvffR50682FMA3uFni7ftK5FNZz8qKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB5074019B;
	Tue, 31 Mar 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF161C19423;
	Tue, 31 Mar 2026 04:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774931683;
	bh=iddzIyo57Gf5sB0Ovre3TYWjXksr2WHRb+oWFdACaHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4rVCzDJK1ThAOnYIY1hZm0cimOvsWGzC7jzqOQOpp0+6Qj1GjD0Lyl93L4BwFnXl
	 PPLlzaJgLmyJybeLdOhmLBiuVFnBD/OKEvKZnQztwVaApQ1ZDd6J71rLogh6nltF60
	 m+ccBJDJf2Ym1vgj6/8djkTkxhjN2BOTSPlO+wRMnRs2flSosMwqCScgxGyyroyztR
	 0HoUIY1wS0XwOvccFAwoUvXuIck6Ydat5gjLp6e3BIZ8s7JcHhbUdEVKVyzP10TJI2
	 b7dpVo996xAYbEiFR0vsAy0fqKxrtJKtU15TzihpYJbYXFUOjHJ0qemOvNmexynzy1
	 o2l7lHEmDa04g==
From: SeongJae Park <sj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Mon, 30 Mar 2026 21:34:41 -0700
Message-ID: <20260331043441.67196-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026033013-drainage-stylized-43d6@gregkh>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C869D4000A
X-Stat-Signature: 7fc73jitk6xsgp3ufkc9jnbuxt1q71z3
X-Rspam-User: 
X-HE-Tag: 1774931684-582604
X-HE-Meta: U2FsdGVkX1/iqD1ewaxUI9stIy29A21eqsg9ORVWAjzcZ466nn138xAI35qLGN7XJEmgQW0cG0hjgI7OZot8SPF1FO9xYheNYu5QDHsYW7yMvo4UvwKjvV+vM6sTzlHcS6kMl3pzhfcQo+ylTgvB83TE2o7OCtH+AaG45OaEUx1dJNnubbrbMWHnGCKApZeUUFt8y7ZZmA2cQFBHeIQPofogk3Bb9qHmfMJxR8qIQcHecyadWbTdlflvRzw9MnN0P+ZxN3gzBb0qghR+zSCawbAeFmzUFMrrEALGKKg1MXs1hfQg3d92CuesATaqZGHP01jYK2ce/EAbGWKDRqXwfVBs/lzX7bqn0Vo33kT2sD4LU89qkmY8FYlqkbb8VEFKLkdisWHwOzMnhfCbJKr0cRSmzCe83iois2/qvlF4WnBmDiblD9kfHTFrFvWvRkSkhuRIRnXaGRJhXaY5mD1Bu3RxVFU8BnLO5K7G9SfHHIG53EIvJYrNfknD0lncSl45v2/KAZhyBH2VjoM26PxgxCmfLW4vpOtTsdrOp1z/dXfKUksDBbPsE6TWv11zcCbA1kJ1EvuVxNqehf7vN00VuFBm4POVIdcfWgqWD+xgpy3rPjzwWFCJZ/3Wx+vII6mV+4EcNZNJmoRmagL5qU9ZhTh3wGIW+p1DWFDOs4Yj4xZC3uIJd+VvHYzKTrbWSPGGPj+K9DqElqwO4p6M4G05zsiStTeLdZu8zw4KoS/c93GAXxszFQrik0s12zgKLFam/PpeTeVjqMA5kTRm1y9dHw4vnWR/tjTjnQkCH/a4iRzSFXpwm3JhdluRPOsaD3LgCffkaGVbDU+KNMG3rXno726fix8Hr4l1NtlSWyiLHo9NRVUwxQbwDSUsMIcnPHDGS8cKs28ormqLkkwonVRSi8hGmMIBNmE2nHbVZJhWVlu1KaZ3Gdb/NfkPPru/CtY0ImipX0w+JHL4heOqoPt
 6P7dKWio
 nzhWVcebGvKMCK+kNsj/tpbQ6gbqLwWDeoPMOMvnvWgJLPyK/FOGiwmG8ETF9MRVnxDdIPdk3Wu/sB2TlURZcS5Tei6lyljsjuqcIgcH9luiKKyEHbPTgiU6ifdqq06fRaoR4CdPkzAlb8f4+ZNPYCQ3CinDw1ROMxblBJjc0vx4r8RltufpO+hnv0nM3w3TAhrox1QNRBvK+nbOtt3njNmzXivUPZ80pMld+EAMVx4TpusWLKPtrwl2l8Ojl/9GeuMuPmgWYoBFAKWMfjyiCeJ8Wz8YVgenOB/g18GjPGpNfXLuoguz077MGc00j/pZo1agBXQO3RGbP8Zy+l/jCM/S93+1hTK1eEzJ77R2l9ipskFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 07:47:54 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Mar 29, 2026 at 12:32:26PM -0700, SeongJae Park wrote:
> > + Roman for a case he has any opinion about my sashiko usage.
> > 
> > Hello Greg,
> > 
> > On Sun, 29 Mar 2026 20:05:53 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Sun, Mar 29, 2026 at 08:49:16AM -0700, SeongJae Park wrote:
> > > > Forwarding sashiko.dev review status for this thread.
> > > > 
> > > > # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org
> > > 
> > > Why are you doing this?  If we want to see the review, can't we just go
> > > and look at the tool itself?
> > 
> > We can.  But it is bit cumbersome to opening web browser and moving my focus to
> > there.  Reading everything on the mailing tool is easier for some people like
> > me.  Like some test bots send reports are replying to patches, or we sometimes
> > forwarding bugzilla reports to mailing lists in a form of a plain text mail.
> 
> Sure, but are you going to now forward all random tool reviews that are
> run on your subsystem to all of these lists (your distribution cc: is
> quite large here)?

Obviously not for random tools.  But if there are a few tools that (nearly)
everyone agrees useful and worthy to integrate with the mailing lists workflow,
I would like to.

Now it seems I was much more optimistic that others.

> 
> > Secondly, I have to share my opinions about the reviews, as many times AI
> > reviews need human's opinions.  There is no good way to do that on the web ui
> > of the tool (sashiko) for now, and I think this mail based flow is the best.
> 
> That is assuming that you can fix up the AI reviews, is that happening
> here?

What I mean with the required human opinions for the AI reviews are not
necessarily only for fixups, but also sharing of reviews that the human and the
tool are aligned.

But in this case, I was sharing the review results seems incorrect, or doesn't
need deep dive at least:
https://lore.kernel.org/20260329163102.58683-1-sj@kernel.org

> 
> > And anyway I'm supposed to share at least my review of AI reviews, in mm
> > community.  If I ignore, I will only make Andrew have to reply asking that.
> > 
> > I used to share only my review of the AI reviews as replies, instead of
> > forwarding AI reviews and then replies to those.  But it was
> > 1. cumbersome for me (should summarize AI review and then my review; feeling
> >    doing work twice), and
> > 2. feeling not optimal at sharing all concerning comments with others.  My
> >    summary might miss some points of AI review but other reviewers might just
> >    believe me and don't read the full review due to the additional web browser
> >    opening work.  Also some other reivewers might kindly review AI reviews
> >    before I do, and save my (or their) time.
> > 
> > Hence I ended up to do this bit odd workflow:  Forwarding the full AI review on
> > the mailing list first, then reply my responses.
> > 
> > > sending it back to all of us feels odd,
> > 
> > If this is polluting your inbox and/or distract you, I'm so sorry for that.
> > Please let me know if this is distracting you.  Maybe I can filtering people
> > who don't want this kind of replies out of the recipients for the forwarding
> > mails.  Or, if you have a suggestion about what need to be changed, please let
> > me know.
> 
> It just seemed odd, and might get crazy over time if this happens for
> all random AI tools that happen to be popping up now, right?

As I also mentioned above, I agree.  And seems in this case I was much more
optimistic that others, or hallucinated ;)

> If this is
> the "official" one for -mm, that's fine, but consider the distribution
> and intended audience a bit please.

Andrew replied this is not such official and recommended action for mm.  I once
thought this could be the official one for DAMON only.  But in any case, I now
understand this can look crazy, odd or excessive to some people including those
that I believe.  I will think about a better way to use this tool, while
keeping your inputs in my mind.

Thank you so much for sharing your opinions, Greg.


Thanks,
SJ

[...]

