Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15372CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0822A6B0088; Wed, 13 May 2026 20:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0328D6B008A; Wed, 13 May 2026 20:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AB76B008C; Wed, 13 May 2026 20:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D801A6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:32:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ADC8A0295
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:32:38 +0000 (UTC)
X-FDA: 84764149596.20.B095FF7
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9872B4000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:32:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778718756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2rmwbpeHjcZpkUuhMPS7+o09sopVSD+p3hwnPEuHeag=;
	b=D8Ij6ZkfdBIm7CrvloOmyjxCKHacglMbpCXxZc6Q5rd4c/3l3HoEfYKGzRpP45x2V5dyIQ
	gdoq+rhPRdg4yAZ1NTyVXX1tI+5Jrt9XG3qHLeoXdlEZnzZiXsCH4l3qX2yit/mLbUUWyu
	WG/Bs+6rPPuL0LREU3V3m3m67UYym3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778718756; a=rsa-sha256;
	cv=none;
	b=OQ2tjSH/L3U5cuHALrh7trV9sL/EQMx8/QQa26GOL1+RG77/O/5km/zayNpZ6Xac/dFZdJ
	8c/5ZJs9U0CTOLrLVPl3GWWTdBEF01oPEufGLhsd3kqxYan+4crM6aAQ/M/Xp4rXMWSLnB
	nIufaKzGZVIrCptKZMfXAvjmIsjYC+Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94A191C11E9;
	Thu, 14 May 2026 00:32:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 796CC80012;
	Thu, 14 May 2026 00:32:33 +0000 (UTC)
Date: Wed, 13 May 2026 20:32:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 18/28] mm/damon: trace probe_hits
Message-ID: <20260513203237.3b1b3286@gandalf.local.home>
In-Reply-To: <20260514000611.147809-1-sj@kernel.org>
References: <20260513140732.2320c563@gandalf.local.home>
	<20260514000611.147809-1-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Drorz1uVBPoiFEF9d3VmNbUHBoYhgttA=
X-HE-Meta: U2FsdGVkX19Fgcfxj6eEgZI8dKFbLpf3CMGSFuh5fZTv07YYNZP9ski4yfmKIMbsARMuVUCfLSrPQXuwW9Jt7Au1AA0c1h/ZIBB4uQTIbG98QG3Ee73ZN1eDgDn/Z1EyKwocs/O1qW/KmP75roahgjgWdjydR/Nq+Z1z04eg6gqXBFLrEYRjZUvG3Pm6HN3j2gVo5MUsmJwsTtmtymnYa9FKJdnMwdS/D28AEhzR7aMDtUFszLxgd6LgUHk6Uhxrh39GzCorwekrxYt9Os2wku+Kg+jKYmeB40a0G1XyurZOZcs5k4W+8mXsNNtsIxm74kVhvQl97Cf7dIbVv4GRIdHXpgJ+TTSr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9872B4000E
X-Stat-Signature: a8bs8djjyouc63otxh8x4mur35woi7mp
X-HE-Tag-Orig: 1778718753-409660
X-Rspam-User: 
X-HE-Tag: 1778718756-900079
X-HE-Meta: U2FsdGVkX19akfw4hwzBP5cD9L0th+VGTYaa9ASsaYX+fRF5iYgq8eAYnrn14RiziZIYqDzltVIRBX8S7yPDxZtvZc4oSoOFDGBB26JWNP2iNegS7T/Hf77opxMx5n0cGz3BwndxhewfOQ15zjNYGjzeHJuXtiAtpMwUgcnbSKC8gbxWGSd6K7fOZYYPNU/tWW8fVLCCsBRo8WTsFoHBISaHAUg1itcNy0lHgtv4td8WzNGMTyisjrrfLOuM9Ju8AfOKDK9L7DBBNdw6lHVsz7Y48sxNNKxYTGyDvLkOmXflxBHW/EV5R8yArJGtbDU63l+Cx0FSWrGDvDb6hDkjTIJ3kNCFulAOdBiam1fI9Vfag18KA6LVovimD9MdRWIIm0iCWVv86xpVlZhbTiuBS9cBLKEQBOx730qUJ/zLccJADfWeQYQ6v473qDWg34jYYBCEMO2t82yKawyffgpll8UNq0NoKdpp0kTf8/rcXo/63dbJCs9pkc0mhzGBtgO6Ed7oMR5kCMZT3qV8rivjSFYDkGn1rdBEtKaAmnW/U29slpihZo2QUD8U+inE8ULqmmkL6uUxj2j0iNWa4q1xphfGpMIgvRjWk/XNvPs9D5rspd0bky6F23D0hGcmnSK9Yq6Gn7ibR/TtY64vXzcR3el5+AgnMj1AcbwNku3JXH92c4qVlVDTKqad0D44c+p3MPDU8vdtvmxNrEL5UzDcjICv8ir1YPvKbJFniUXQqqawkM+/5mM0mhiBq9mRW+1g06wtrTMBkrln4L8cl5mq+0/4YHr7XbuftS/Nx8B3Q/PbNHvxJtJ7wVmXDst2BpxZT+39ZLhfRv2CjkJk3G/v+5rz53YWheuk45AT/pFMS/O6SdeN4VsiQrQrqbdQWniEvC+p8pvL/lH9N6h6dpThEQdEFCvqFO0cok+BEmlXJD+l7uFAML3+enTSD7Ygd3sW4z7I3e3ufZ6tStSfRyk
 yyvtIIUp
 zv/Xm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 17:06:10 -0700
SeongJae Park <sj@kernel.org> wrote:

> Btw, if you don't mind, may I ask your opinion about the name having '_v2'
> suffix?  I chose that as an RFC phase temporal name that doesn't break the
> compatibility, planning to give it a better name later.  But I start feeling
> just extending the original one might be another option because tracepoints are
> not strict stable ABI to my understanding, and the change of the TP_prink
> format should be simple enough (append the probe_hits= part) that the user
> space could reasonably deal with.

It's only a stable ABI if some useful userspace tooling depends on it.
Otherwise, feel free to change.

Nothing really should be parsing the TP_printk() format part as it is
really inefficient to do so. That's why I created libtraceevent and
libtracefs to do the parsing of the raw data for you.

-- Steve

