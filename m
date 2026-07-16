Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF995C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C626B0154; Thu, 16 Jul 2026 11:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2930F6B0158; Thu, 16 Jul 2026 11:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133076B0159; Thu, 16 Jul 2026 11:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB77D6B0154
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:34:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2134416013F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:58:26 +0000 (UTC)
X-FDA: 84994492212.02.D706E3A
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57CF9C0004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:58:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="o2t9/oQM";
	spf=pass (imf28.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784203104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toaUztrSvNj3kdZ0hYHuWC4I9HtWac7I1kBUHNoUIdY=;
	b=28D6IUKQDGS4VgX9UqwHaPmPb3mQFWNlhkCDilm/Tt2pDQYlvMr/TCwhR82DQ5S5cBxr9i
	lYYVXuc0LOtkhZjMhxa0G5ZF7++zHBBRgcME80nGvmMrAISLCV5IkSiZUiTIGL6GQRlBxt
	hIzV+ZWi4L3No+N7vSE+DRnDwsBkNzA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="o2t9/oQM";
	spf=pass (imf28.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784203104;
	b=LrHPhnYLl++2Rmer7B4A4k+WDFVZ0Dszl1ThwQa6isY3DOHITILIapLert2F1rwjuKOXim
	0/QGxKibOCTPXGRaJbWl7ht0KXPVBOQeMc8sPjK/4RLl4hzfARbRRHSrIJqQrpEbsRPzIf
	gzdFdowAK2Vz1LI6/CRDi0sNxNkCwDg=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38dcbade417so4712924a91.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 04:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784203103; x=1784807903; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=toaUztrSvNj3kdZ0hYHuWC4I9HtWac7I1kBUHNoUIdY=;
        b=o2t9/oQMBhskS9ogJCVOvYgPAp6mq1NMZJP7b8HqwtEIOa0rG5FPUzcNjhF42sYu3J
         xpXbWGkD1J3tE+BpqJNCQ1yRRK+raer0cRMykE/0U752JMhODvu9/C1x+UyVSVjTu4BJ
         f348TTwFgWRznoeiF2icPYdVMJIIHbY+lQZrG7UxwmxkvTgNT9l+8IrTOU5nCy747Tnf
         V0AlzecFWkrvVkUtALXFV+mLTQDxjdklBGPE0lXJSbKz6xAFKM61qX0z3BmyS6p2yOHw
         edydtEmre8/P4H+FqpwSGaGYgU/xRotvuF3S3qxEnQrvl3D6hlKn2zgPsRrCRZwtiWko
         4QDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784203103; x=1784807903;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=toaUztrSvNj3kdZ0hYHuWC4I9HtWac7I1kBUHNoUIdY=;
        b=TYTPcx2zXfpG97zJxejv6hwPRdkQo9LjNNKOiDd2PTGa70juqOUD39wQ0Hi6FxzI/v
         tK3dQwIZxg/FRlWaaqr2z0JHRIsivx/f1IQbb1el4LNdm5DHr7Fo81hj6B8k0ITHMB9R
         IY8HFWwLWLskDkZPJqWtEYCbof677bYepPsICRxxr9PlRoey34eslW3bCPwNvS4A+iEu
         F7q7E4r4gp6/7kvWBY7bp680OAkCCLJoymzy6QI5h5WeNvG5w6GtmdgIf1Zd06GquE3v
         7AU/SKBQXvsSz154cr0I3sKMzI9Zz7cbY/4HQ+WLHAWV8Bq+Vx8q9kLjJln4DnFCgugQ
         BOyA==
X-Gm-Message-State: AOJu0YwuJwP3DIBw6BewZHoefO9wwgV1st+pNJp6AUG9sMrwx6ZrIVdl
	xEAZ+WCYKVJjcDpVrLitXIHLaC2aKfsQZY6JbjqiKQFWh1EoKrWEs9wU
X-Gm-Gg: AfdE7ck+uc2Sf+biwWrE2J78FBsbXdpigOogOafF8AMpnrOuvf3iNQD8i/XJAMGy/Lj
	hdnb5KPKbAkvSv49Lfi+X+Idp4pu3v4oQTbNPp5OhFiq+5xClbbhifIJXPyEEf9WD/d++RDmHOJ
	GrjERWSeQVsP0D0OKaEaQGWwCeNp90FRtmcc16sEbjKC4b6aVHJPh/zQkqgOF/2nQ5iIKyW1QhV
	xw96mAPkX9E9m8BfVemE2vW/3DPpkfpCdyfzqpkt176f2Xhv9OFbMTOJvfYP1gW3u3IozJIDf2y
	81Aec3LiXyPAGgpmfzcnZS1Y083ZrF3qh6DjjhORibc+CwgPDvFrXcwBQ8xg7rCAtTYwj7avxa4
	DEz5AQpph4unBtOzfVw2nLsOREsmo5zWjJfLHb4Ln0HRSl6vx/jx1TTQe43LLDMgbSlUnGzhZmr
	O89lbe0P4rJnILaDAQqZNZa+JrbLR1yDfwaw4LJ5iJ
X-Received: by 2002:a05:6300:8941:b0:3bf:ba2a:6a8e with SMTP id adf61e73a8af0-3c34d583230mr14643765637.21.1784203103217;
        Thu, 16 Jul 2026 04:58:23 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:9c31:f107:8086:4204])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fcd26sm10685491eec.5.2026.07.16.04.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 04:58:22 -0700 (PDT)
From: deepakroag <gaikwad.dcg@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: linux-mm@kvack.org
Subject: Re: build error in vrealloc gfp/flags (fixed in v2)
Date: Thu, 16 Jul 2026 17:28:17 +0530
Message-ID: <20260716115817.81400-1-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <202607160153.yE2uZTbP-lkp@intel.com>
References: <202607160153.yE2uZTbP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5y8ujr8i11whub1yydyepqwk97kdwyop
X-Rspamd-Queue-Id: 57CF9C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784203104-897620
X-HE-Meta: U2FsdGVkX19RGjO1g1FIVIJDLTJeYxtg8Qtn+Km2wYHNZvrEBZsXynNUJwqRDAb7fcqhQ6WbCEZfJGKAoJlipDtyDAzzhbJR0Vamy91QpIJhX98LzrbEMlrdQWIjiOPYaxS2J+fDXJ4QoT9pgqcPMRUCEUCyifCxJOAK7Yrlxp+3IzAvk0F/bP9DOmuLTWM5GpD2UbqiZ4ZWpTlM3Hh65W2rBJL6p1VWR8fjwLdhyQM7nfNTkC9a8BG4//RJh0PftHFQ3OJbOOWBHQIR3LxOvNBSvnQ+lwlgnKmVDydKxfS0kWhMzc8uI/eXPYDr1AjG+z4nngMhApsOI1BRpmQYzWj++xazKHfyaAtmd0pIZteqZB1phBWO7lPWD+vGRq2sOP3vCkPowvSFgL99StiwYhfUleMAKXHWq7GU0O3+3ht4OWWuIkJylta4leWJN19lA89LMv5Su/6Oz5M7bWg38UpGLGpeCriSuhPhSbNo1R2VF8q64Hn0jq0c912hZD9LZ/tTEpVF1sQWsEVBkyd2KvZH6899k3h2ADfkXKKGoILcHLmJ3I5D8ahev0kDzQ7MaLUJ2WqVfxd/yN8NkF4ReFgGyiOUvY2CjLiBnq4OOx60L0TmQqRfgNxJBjX4NtNI1kOXblnWbTf72k+ywZszNw5kjstQtiSTVZWhd7seF131vXesZ4K85kC/uyb6LtEW6Yc5HpBmFkQsY3bui22KLHN4zCOjJnLOgJ4TSiZeW9p2X3ayGYENRrjoUSKWL3h10ShPojGHQbXZtraxk6CEMvbHN3MBhpUjUZFGmfTtJ/lZSjs0O7amyqAlAQxLgeP3r9SHrHfmI/RKDTKF9Bcm8+pWRFzAyXMSvyYKtaU4rmB6kU1nssZ0MyHbYD34p6cfnAjJw+98z3+H1oOyLZeCnMr4VhNYVhjqIRy4sz4vfPQB0PUtk9NmLqr3ncp4AESVs8aeB069ILsP/ScY1vW
 r4zfjOsJ
 ESwj2p2KApH2jak5aJA8I4kZ5Y39bces8mKv0dtBSakEsN/zzAzZiR4TrLQwpRgIE7lSs7EvxqiehqTux3TtPrEnXTlPxjWfT2RUNcPkrMpPMx8tBnJkV+RsHZd8lPDxJkJLFrh+0CGc4nVKr7nWPbdsWRA6M4VC6dcgt7xz3o9ArawnCm2m4utY1Br36m9GY66YtMbgvG0lpnVMRy5gfX3g48FzEdCqOESEeL7xIIl/jYBKxKiJFQibeWZKdayXqbbYz5Z7Qbm76x+tpySDgItfbvdWrOMdDKxBNsSic7DGAssRaOOkzXoSL+PuIesI62y+4OU8RSHzG8b/wfaMTsDpDAWtTNIa8GbiIDHEBOCZq5oEccIFJt6hdSKy+4FYxYLdjO+Wy+k7mzWD67FmDiE8PD38RJshGZenQ/cDpyIgtvloHvW3VhWND22H3UygApXbPxkBuqrhWJ3/ceFBGdjlU19PCwLiTRlmmWdor+dUq5jk8hfC9IHLtJBWFuK7957L3XwbQ23Yn6iRUzCN0ybkVYH9LPCF/9GMC65yH/F5ft5ZxsHvItG9XHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 07:23:53 +0000, kernel test robot wrote:
> build error in vrealloc in-place grow path

Fixed in v2 — gfp→flags compile error squashed into patch 3/3.

Link: https://lore.kernel.org/linux-mm/20260716115734.80909-1-gaikwad.dcg@gmail.com/

-- 
Deepak Rao Gaikwad

