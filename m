Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE45CF58C3
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026906B00AC; Wed, 19 Nov 2025 13:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1546B00AD; Wed, 19 Nov 2025 13:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0786B00B8; Wed, 19 Nov 2025 13:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2F6E6B00AC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:15:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A49D959B50
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:15:12 +0000 (UTC)
X-FDA: 84128158464.05.E494BB4
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDFF51A000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:15:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763576111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIuLmBvJGEgl88ztDhola3fxMxL/AoWO5SWt6LxfA18=;
	b=X14gJUDELC1y3UbY+oJoIKq1lFPNQh/mCkz7deRVTHsx6ws+ZDnEaaV9IgDbFkjOhTmAw8
	2QUu2NqpmU24lQaDNZ4YUv01EN5OP2VSdj7JglT5+UpBGysWiKf2abbmkj6AtPYSFr2/JZ
	mWuHYovagRp4HnziKl9gFfzXRLUeUi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763576111; a=rsa-sha256;
	cv=none;
	b=OsQmcbae+mVriS2o1pEgwVOCyRjTPAe2InqeZjxzQISWpAvG/MPmD0DZg/PCe7ekmz+ifZ
	xO4+LLNqJhhzSGrSQTcmAi6ntQJCSWGsu7Z7epY4rXw7jLpLoOVmmykD3YCkgHTOd4rwlR
	Sb/jKrlNQlzCgV73K9u4qpOGemfnDac=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	none
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFF051605CB;
	Wed, 19 Nov 2025 18:15:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 4A57120025;
	Wed, 19 Nov 2025 18:15:04 +0000 (UTC)
Date: Wed, 19 Nov 2025 13:15:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, linux-arch@vger.kernel.org,
 tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 00/26] Introduce meminspect
Message-ID: <20251119131534.392277e3@gandalf.local.home>
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18O9iohKxcGmRjhPgfwSwuiJ9rXjN3k9nI=
X-HE-Meta: U2FsdGVkX19/dF/WOecvGV6lYV2teK1CUApQEXvTil5LrDYtCitVtAX5Q8BoMR6TmtJI3K/ypigEykJDoh2wWRnxnwtvEhfPbYoAjQ7CBjAeAkHTNVC2+UPbuQJ52IMkbLqNh+TL98B+sVLbcP7iY87xUXSqyp7/t07x9SzdepLahdbj0fgfKmabVHXYF55/LhPrKLsmQxRGgcdQZc+VoLmHQAiPN84RAg7rXsAjcnFkeEgslDnLord92S38kLD1z8wtjeDd41ff0CQR7dsMu0jXGRqJkaVWYDB1/V+UlnbDyZgQu6Yb6HDVSBXDw9IZsLZGyvuBTwcfN01rmgeJINsoleI4q+rVGxJsLPdqn6YSut/diszZtd5o703j4Xy2
X-Stat-Signature: dck3714z1uq53izbbsf3qduogmutqt9c
X-Rspam-User: 
X-Rspamd-Queue-Id: EDFF51A000A
X-Rspamd-Server: rspam10
X-HE-Tag-Orig: 1763576104-213290
X-HE-Tag: 1763576110-523037
X-HE-Meta: U2FsdGVkX1/Np0BCkXLLAkJsuwV6A39vcNuhtnZs8trE1YXnhy7JTT9OHTHQRY34RjqS+VetRmawtDK9JUWeVZNenm/bzT1IPuPSphBNbwMGFhv1w6q1x0+sHQBwx651FoXSyhg1u6phkYUI9NdYfmZyG47/1qBrQNN8m4DIpmOpSNrtCslObKZ3OklYSfoItaGxAgsO1M/GRkfPIfVBBsCUqVjfbfTdlWcGUpnLkH4pYcidw1xEHQ+D5Vw82lrbZn+qfsl7uRHuJtJrp3hQZrzWw8sX0SajwfXJlNP+yUcMuT9bqNpqBzpyRRhpzUr5TytqSa7ElEAkj7DuLPpEz/33Fk6h+nFMhdObIpZ+0v06nZgb246z9AG/8G2YohxN7mlDHq4G8nUODaqSZ/WiHTfQA0WWU5yJMWPkRqoPuKGvGlULfmRJbKbbWe1jJAsfrvgrFhfLx72QcMjGCEBCuG4LpE8tHug+iyiw3eZmC1VeYNFowqaWUHpriLM/12c/rvtLK2QEclZm1kl/XPmJRLtGs9AqX1K2TkhKJSbfpdHjpgJOjDaYRj9e8NrnozubJ5rsPvSqDOht7Sn4MKKvYVOTr47GifxD7JJiT6gYsx59KmpuG8rhL/GgBqyz+7eSZa+88MQOuQRmDTtFRbpTvJFMdj62Vl2/dYBDIDGSpBLA4X7O9ZwU1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 17:44:01 +0200
Eugen Hristev <eugen.hristev@linaro.org> wrote:

> Once you have all the files simply use `cat` to put them all together,
> in the order of the indexes.
> For my kernel config and setup, here is my cat command : (you can use a script
> or something, I haven't done that so far):

Interesting.  Hmm, it seems this could be used with the persistent ring
buffer code as well. But if the firmware does not keep the memory around on
reboot (where the buffer would be reloaded), you could mark the persistent
ring buffer's memory to be inspected.

The persistent ring buffer creates a single allocation to hold all per-cpu
memory in a single region. That is, because on a crash and reboot, it
expects that memory to be at the same location and does a verification
check to see if it contains a valid buffer. If it does, it will recreate it
for view in the instance directory of choice.

Now if this same range is marked for inspection, you could then download
the entire contents of the persistent ring buffer after a crash. It would
be trivial to update trace-cmd's restore functionality to rebuild a
trace.dat file from it. It would require saving the event formats of the
running kernel before the crash, but that's not hard to do.

That is, by using the persistent ring buffer code with the meminspect, if
the firmware doesn't save the memory across reboots but allows you to dump
it to disk, you can enable tracing within the persistent ring buffer, on
crash, extract the buffer, and then use trace-cmd to rebuild a trace.dat
file that you can now inspect, and see the trace that lead up to the crash.

Now I don't have any hardware that uses this feature (not that I know of),
but if others find this useful, I would most definitely help them implement
it.

-- Steve

