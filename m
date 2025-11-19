Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5ECCF58C8
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FC36B0012; Wed, 19 Nov 2025 13:38:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667206B0092; Wed, 19 Nov 2025 13:38:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB636B00BD; Wed, 19 Nov 2025 13:38:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED896B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:38:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 002928928F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:38:14 +0000 (UTC)
X-FDA: 84128216508.02.DA54D24
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B38C40018
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:38:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763577493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pv0XlKeHKZGqLBZRpSk45yrLMGSlkYdrCdlOGgiMXMk=;
	b=tUMtFTbl/eCXxin/gDVShMvC18zVznVeKmNlXlt2ARE5inMsmd8cNyJVDnVoMeqiIik7Y4
	S/JQWUz2vl8kjPSI4VhsIf6RJcmkux/x7lMdRUhMr3DujgC8LUuGHBJgj9q+3AxsbJX0aV
	nT+9QB39F6FZhQ+Ff1TkIAk+P8oKg7Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763577493; a=rsa-sha256;
	cv=none;
	b=V9s1NJUexHx1yHzYt+j4fi5N/GfKcGqv9QA92j3D+g+PLKztzOjP2CcaRdylyorScoHF4c
	Uzw6b5MZtL/WFgiHDbKplOg1v9xLeljUmRC5EiSj8s/1zqik2ixAE7gUMTmfMqIHk8dT8T
	K7xOSwGim7q10lDfrOGYNkU/P/hJYRA=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8AB716060D;
	Wed, 19 Nov 2025 18:38:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 81EA330;
	Wed, 19 Nov 2025 18:38:06 +0000 (UTC)
Date: Wed, 19 Nov 2025 13:38:36 -0500
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
Message-ID: <20251119133836.47d9ae73@gandalf.local.home>
In-Reply-To: <b0102b82-9ae8-4e01-ba27-44b78b710fca@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
	<20251119131534.392277e3@gandalf.local.home>
	<b0102b82-9ae8-4e01-ba27-44b78b710fca@linaro.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18eQxzjFElSFMQBkWmqdnIUBJkOF0f6iiE=
X-HE-Meta: U2FsdGVkX18hYyFLn4NceFAtmtr2U9i2vMLdUUZa/XY9sbc18Qd8d0XqWxwjkyLUW391A4PmfVST6fTOPo9/v/GlV/882/v3PjE3Q5zfS5DD1vsLm+4ecyYB6S0zd8UbhIjnn5oMxPSN9iXqq6UxrC6D2V+tXEx8ZTe18jJnlx5L3nYf++HdtV6ezZc8QQOsd5Sji+bCYcQ6BWUI2yZNs93T38KE14+xuHs3A5shJ2l0kZqx610Kyw6apiwgHfwv9/5JD181MK+WYyNpUzWoatcjkFOIYbmW/eiebkRWkR1PTFbDxKfNL2AREBIQ9kzXso7tg4Agi6AvAp3c/q8HXYwDktY4Ul7c6O7qpQnkvKOsmFMGedUEWwFLRTKDlkmz
X-Rspamd-Queue-Id: 3B38C40018
X-Stat-Signature: nz868fg4fgg5scpw69o4a6y8gox5mp3f
X-Rspamd-Server: rspam02
X-HE-Tag-Orig: 1763577486-542771
X-Rspam-User: 
X-HE-Tag: 1763577493-196023
X-HE-Meta: U2FsdGVkX1/LbU+ef9U3vctbCtbHYSt/RZekxLc8/RFP88aGly4S0LJPXY4+9CFDOMI7DzGh/27yFrRQVn/UuiGrOd91n8mZgTIpBDOJjUQPkA9HiRIq7SNXlL+zy6fvwooEMaeujuAOUN9D7WmEEVwCyHEHvVkQdh3NAFJEBULecSsuqoOdhax+9FEum4qjIKCulAAl1j1aj5Cm+5zl/juHonTCrz14oRa5DNVJUgv7EfeDwVTyvUUccNVotDAe3vOLWE+8v2MN6IAtauWw83Gs68/dNvCb5kmIh7lHx/n2A+omAcQ6rf+NrG/waOSBKTOFj8+WConsfFtQhyctXZwW/m76RE7t6N1uIJMqZMXJ34qJ0N5FQbPT3ypeOLdDSErhvqzMGtXWfIAki51jJ3l06M9E5Ls68iRioMbSxLGnSYV2OK5Q+Qp/Sxk2MIN0OlR0NVmZqrjdh3XKtQE/L3RQXh4tHdgqtKCjGHdsrRSpxwsYB04ysOVG8o0uy5QCrYcE7ojtoy2qoimkXRa0zTIVbekYXxU72Q8Q7i2FVDVmIuH91vk13S/X31qD2xFO5ktyXk8GB+H13Q813/9EUVfs/LdLY5uuDExOJkdx18fltKDNi7QSMmWCwE4oRmo09UOdQaVgCSJXneIyffaUNshqtuWYGscGu7xGzO3ksDaxTkPPFXkmtgDMreooezfD38lInDomNReA1VpOARfOAkvEdcmWkJzLwskIDKfhuwsssbH4+GwE9ywT3lvpzc+0xjoP0UPsBu5Gtx9aWY7+WUD+N+U+KdA9xF5KrL0HL5uQ5Bs29Cy/br5RhU0qpTStHod0kJlZm7QJcYvcL7Mmj58h0sa/j4Pf71Ga8J9qqGhH9WphY9N9W9kqvOBerHV8ClcZaqww76U9EId2YvC0AeMm+FjgcbZggiRxqpT++CB5pFi8AjtSf4f6a7b0AB0uFcNREEZffEy6pbO5qmD
 yAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 20:24:23 +0200
Eugen Hristev <eugen.hristev@linaro.org> wrote:


> The problem is that all the meta-data is not allocated inside the
> preallocated buffer. The meta-data is kmalloced all around the code. I
> mean the structs that hold the information on what's in the buffer. You
> know what I mean.
> And all these kmalloced things, turn out to be in order of hundreds just
> on a kernel boot, which I tested. This is not feasible for the
> meminspect table, as it would get overcrowded very easily.
> I thought of perhaps trying to kmalloc all of them in a dedicated cache,
> but I haven't progressed on that. Another idea would be to try to
> recreate the meta, but I have not found a way to do it yet.>
> > That is, by using the persistent ring buffer code with the meminspect, if
> > the firmware doesn't save the memory across reboots but allows you to dump
> > it to disk, you can enable tracing within the persistent ring buffer, on
> > crash, extract the buffer, and then use trace-cmd to rebuild a trace.dat
> > file that you can now inspect, and see the trace that lead up to the crash.  
> I used 'crash' tool with trace plugin and I am able to see all the trace
> contents, but, with the limitation above. (To achieve this, I dumped a
> huge area to include it, so , not feasible for my goal )

Can't you at boot up just run:

   trace-cmd restore -c -o trace-head.dat

?

That records all the meta data of the running machine, and places it into a
trace-head.dat file. You can save that off anywhere.

Then after a crash, if you split the buffers up into individual cpu raw data
files, you can then run:

  trace-cmd restore -o trace.dat -i trace-head.dat trace-cpu0.raw trace-cpu1.raw ...

And it will create a trace.dat file for you that you can read with:

  trace-cmd report trace.dat

-- Steve

