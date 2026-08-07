Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0583AC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2486B008A; Fri,  7 Aug 2026 16:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74576B00B2; Fri,  7 Aug 2026 16:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E076B00B4; Fri,  7 Aug 2026 16:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB786B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:26:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FB6C1C018A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:26:52 +0000 (UTC)
X-FDA: 85075607064.02.5DB7D5A
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id 591841C0011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:26:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cSVRSCYcY1KrSikxm2IvKFXjVYA3Y6TaURRMmVNR4BU=;
	b=N8n+eGqbY0NM9xJjNlAQ4POrFy/MI03nhsmGaHrtGsVE83iN+2Gm+Pfa0TpgM6cFgqFdqf
	sR7dIqqkc7mAc/x/zmc2Apv4sGoxPC44FBsYOA8QS2wsuGgUkb6/TBxJ0P85ttWYVdCKzY
	yLhJuOS2t2jTUUIroiat+b2YoU1AXcU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134410;
	b=NDgmIuRb4VqsLINipjp/1LTbOnNcUNW8v1wi4ozPKiCdxRD4OJkt4erz0FBUCebkvNnDsr
	nhsTgaL2yJXjRGSpx6BoGlKTNsn64S7Lhll2BpLykGGA/j2Lqw4C5o8r1eMhvrje7to6Tv
	rCMF7uCuEf/aKueVpwioyNmcy4T75jQ=
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64C8D1C0129;
	Fri,  7 Aug 2026 20:26:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 7737920029;
	Fri,  7 Aug 2026 20:26:47 +0000 (UTC)
Date: Fri, 7 Aug 2026 16:26:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Meijing Zhao <zhaomeijing100@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] mm: trace: decode architecture-specific VMA
 flags
Message-ID: <20260807162650.39bc41f8@gandalf.local.home>
In-Reply-To: <20260807125054.d69baf2c6df589ddebbccd48@linux-foundation.org>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
	<20260807031349.3119855-1-zhaomeijing100@gmail.com>
	<20260807084745.5d96995e@gandalf.local.home>
	<20260807125054.d69baf2c6df589ddebbccd48@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/wtq6mZ3mj7GZKTASm39xBdeVTg10hpJI=
X-HE-Meta: U2FsdGVkX18pZZbuCnnOTQtC7FlA3k1Q2A4gaQfxbHuzzPjWoXlv3tbTvmitFGFZN1rgUXM7Oo52m4LdLgj+hnHKdIq5ATXDvIkDiVU3bGrbw9704RkY+bQV296ca6Lfjp8lEbgWZTXq5W1YTLUZKHkmrj7bENINWwyHlEsYCiDCRtREdfAZJ219p/EPbsse+Jawye1CqjFitUuvuY4rauO9Py5AJrVqRyh0hSxXN5MNT/CnwPWNoQEMeDdbEpYpNwqHe5F4jB8JvC6josSVhM+WN6a3vaotbVNN3Yx/SOxqaMkFbCHBQPHGgOn2fFESVPW9K4ojthogDSIV9A3Gc5/BzKFKj5BSMkeqp5qLSu+/JY7Swn+wYoFTHo8ewVXU
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ez6ax19jgxw6t1t7pmxddaqbq6e6cnx3
X-HE-Tag-Orig: 1786134407-711689
X-Rspamd-Queue-Id: 591841C0011
X-HE-Tag: 1786134410-781683
X-HE-Meta: U2FsdGVkX19/P3NKhXCJxWr24DABAzKMIObn2YamSIKJN72O4uvxIrduBJtyHG1SYEhFkKQLchE0GF8DAdf6Hy8OPkjKd5tkYxHUETFmFeBpkB3EqIxH4bWCIcfpdAKpqT85t1mcp3XOeW4qSZIrRUVHY4HFWl2G361xKjOHwbyyD3u1tM96dWbDOHX1odyhVWPY5ldIrcMvAS/nN0jQHe6eTJywVZazJlNVuq9JMyuSKWV127iVo7NEEXuEZo4PmQKKwaN6PNusyzqCuYlqEpelfN5BkmMF2jmnJACNX46lXhwVTg9o1ddcZk3rd3SOkpXYOOVS+7pBeZbzY2WZYylEu3zkXocwCb6ARZ+UyKtje7dXmWz5By29ZiiQeJXEFGWEfmStgnGoy8w7EadnKTNOavv9su+YNOq9yB58uqf2k+z7WhqG7sh4JuJwVX7KJilKY/9QTRSZ0f+mbSW4/cHKiOqKBu04Xfda9fv4ANdwe9UIoUkz0A8yzDbauL/kkOUnGUGtGs15CwYaO3DBzwdpA/IH4gMWRF58XLEHrCM0ol4q9h8kmgPQQJjAjKqtAf+9+e/uD9fR5m4Y55q5U+ycJmwEUjCC3JcQCM+D0irsDDZmY0h7E7QRZvKAZd64HYXE01LLPTYjRQ0oRIVHps4GNr8qIOjPowZ2PRpHWRhc9m0weLWXuEKsdhPsgyfqN9wECdQa4vGqspfQmEjlU4r/sOBAWhJluj8XuHjUxZvvN/sg83eXdo5FY+kiLuYcdCOCAQsO0pbCcknNDh1lmZ/6V9edqg4hK9PNc43C1qTYN218uy3EhJKnS+DLFD4ov+mG35+HzIiO5qaouT2xmfdzr1qkEAHQnWm0Wp6Bhy10LiV7bpbHpb0/pJWa6/SX5T/rC3pwTsQQYS69IUDSVFBOrcxDYsiW6MVKHSTadAZhG3R0GwInXXRg7f/SD9u8DVJT4C0IIK5pC1OnANV
 OYRa/+3P
 r/fMD79tY4aoJYQL7EsMfVKPHOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 12:50:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> get_maintainer isn't very useful with include/trace/events/mmflags.h.

Someone (probably me) needs to go through and add each of the files in
include/trace/events/* to their proper owner in the MAINTAINERS file :-p

-- Steve

