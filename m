Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F400C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9256B02A5; Tue, 18 Aug 2026 11:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A346B06EF; Tue, 18 Aug 2026 11:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897026B077B; Tue, 18 Aug 2026 11:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAE06B02A5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:57:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB4DE160116
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:57:17 +0000 (UTC)
X-FDA: 85114844514.08.733F6E5
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2174D100007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:57:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GHCrDmW2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787068636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJsNbFhcAvc23yP9oB4/NO35b1/oluJDB0GRajdvh5k=;
	b=bi0TBhLzz+Gz2Vkr37Ha70o6rHYb52G27tG4SvkZAn69NOzUOGnxydGu05b3CKF1OhFwAp
	V14//yV9mAQlPohy0uqBpzoHlh/E/4+zFdEV0nphBjWjS5DGEcOWtWfHhty0DKZFMr2YHu
	r8fe+wmJlDkkPDX+3muCdfYAsLkSZXE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GHCrDmW2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787068636;
	b=H0FXiqu0JzPeXgE8jnDF7WNe5I+V4uhvoG6DJ/VCG45P/Zkc4h9cgXgy4q6ZaTyYkifbKD
	IaZU2z3tE3kYBlDHc+fPgHXObgMK22NLbDy7iMTpWIFD85BZxnOmCJ7xyHsdGVXp72A3Yw
	B+fSWyLsx3eae4jUqvscLEgIDgNpxL0=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb1dc6bd53so3486151a34.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787068635; x=1787673435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aJsNbFhcAvc23yP9oB4/NO35b1/oluJDB0GRajdvh5k=;
        b=GHCrDmW2rXYIxfP4pZpmjqQh826hYiprywvtYwM7lFdYOUKjO4hwS3K/ejvRvkr3wQ
         cYWgNFD74fwchyTzU+jwb7HKvMMICRH+PYu2U7yOpMLidLxP7qGpqnk4LDhKKN4s8TJZ
         SWeDDP7miH/RwqakeKRhMAUsASO+cFBiPcUAWTVFsqB3FkM5KNPWoOGGZU5dhtjzwCj6
         tqiMnYTOxJ6AFE04kWoXJ5/2qF94dQGnYKUBiDjhapXyQrJ4sTjtquawOC1pTJutl2hr
         0hziR4BG6HzI67COqBBsIw9RYlz/EfJdf+7vLCA9iSnz1gxSulTNuNv/kGeHCw4xctZi
         tqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068635; x=1787673435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aJsNbFhcAvc23yP9oB4/NO35b1/oluJDB0GRajdvh5k=;
        b=LpbAJzXo0RyyjKAB9mMjnLV/hXBE/INo0L3I77mnYg6JNXy/6ZQ8bIwSA4nQTAEoW6
         ayf1Z8CBWy53LV3J+VYFNw9fanPClAw3sNnSM4+N5fuJpdWuNUiv3t5/JlQcYy7r+Phd
         3io9xHfZ27HInmzrFD960/mQRhYlZAqqpko5D4mGokXNwmVR+Kgu4fQvZH6HJMMXxbad
         +AUnQlsJHhYMsS6cRawbOgiVisYYJ1pigdQuoZntFEpJWjQ315IaXdRExJ9SNj59XgaK
         uwVDnISxFRbemm/DwGerwG78zQbtkn2flSXkxnzBu8fNL7HkeodHyK/MNI4mFEMozbHb
         CGgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrL+3j1zdhPw3JlHxsbyyzJNohT2G61l2xZuGVPAnBIZQ3C8aAU441yo/ioMy6Lkq3zaZg9X/N6DA==@kvack.org
X-Gm-Message-State: AOJu0Yx95drE5XiE7kp2eLH5oKDePjqzsWMuyjjwhv+VwxXWeCq2pq6u
	q01Z00zIztUlIQ48Eo1/1g6yuuy29RKEVCP5OMb2+yK/l4aP6rDqRGHa
X-Gm-Gg: AR+sD111XrQZUNK47kr0lA5h8HE7KQCBwOdpDvpNHiBkFsU3G8g1oofhrppJTN6T/91
	3ni4GNZsPWHq9EjEbTj7uaGS0vU2Hal74iiwbqBV+ne8n30GPt5rq/E9/ax+4msDdV78CnwHsQJ
	rDpAolCvVa+p5rKCKeUB1tL9xR/bQKytIR8IvLV6SIpo2S7PCnCPnofnBUbXPozVg7Jq8VgJKay
	43OnRtgHrxgOCqqhWFwdc+POXdZBvqYDIyuEgzY6kuSNDlkIUpyuPdYWkVINDKoskA3WSOEOe1G
	VqhwHPspcPsiZAJ2B+MxUirRZe4vA4R4aR2qIqGDsuEam0hcBaww/R2kKRdKpfdntsWkkCX/iIT
	yqK0N2wvgF2cD8lKLKm4feMr/NT0GCQ4rEXhj0PVhQxJKYS3EcPnFfUZmxaIlfMgizHBc6xsdB8
	TIuwJeEyFwSxUBMNv7lbtj5EdBBYqPKQr6m0n+blp4QiNPgo7kWEBoY+dNHjaTYWxKBzHcA/I3q
	zttZxgxOq8tFe5IfOtuxp+qLPQ+/sYXPRZgx3961lSc
X-Received: by 2002:a05:6830:63cc:b0:7e6:f7fb:9678 with SMTP id 46e09a7af769-7f423c38469mr9469536a34.1.1787068634964;
        Tue, 18 Aug 2026 08:57:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0f3598sm5379975a34.20.2026.08.18.08.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 08:57:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: liuqiqi@kylinos.cn,
	linux-mm@kvack.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 08:57:12 -0700
Message-ID: <20260818155712.882286-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoQT45_Vu8KZ9rjk@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1p3kacagw8u8wb6wfjpxax7s8cupya63
X-Rspamd-Queue-Id: 2174D100007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787068635-468083
X-HE-Meta: U2FsdGVkX1/Cj9cvQZ0iHbnadQu3y4dKJBZNIMp8NjIZG33S4OQ/HuuCRyRjpHJ1zIvIOVYPERv3nqrut0qUDOaH4cBdhbztFLohA07TzhpbgOvkxyeldWtBKVlg1gEAa9V+tV/c7kK20XhSTHJfjW7oS04dS99M5ePYeCg0mTmmkdaIXuhigDl/wfpO/4HjtdMcJaIWH7nKp5vFpABWbbiLi7NqjuaFK84Qpzh9Jh8kCA+xj95ZbhW325zVwpFjGPuGsuIDkxpFdVTFIKZef9Z5s+V8zlNLXFq2D2qceURLNYE8PzgFz1d5ciiYkxWnWkye7FHQlEfu9IpbYNtmOuVKgasmziTwXYKLIiaeVu2UZfjYWDZkesQHKefuW4VwWoSrUTXt2m5vppZkIs8+6Otxa4bGcKadVVUV5KJGPUdkzZBEjyRXYFAUR8iZtVrD4zwMIJA3M+wJoEQObJkGhOyTuBcfqOqB4CkHJZZmW7iTgPYSK89VolYJ6UjoQYTwpRyyULt/1v6sbCKFYn7XUQZyQRnY43uTUgZfHX3cajwWXXfV2pTRDF6ESLY2j8I6y+S8A1/rMQU8KtwIXAjpSDPdJ/6R+/brS3z3bSb4D7u4bXgdSIZ8d+uONMk1PT7uYsp9KhdnHLyz5a1+GwODRFMUez83Zj9M0P4a1fM1Lm0Fi5GO47MWrz9gyTAq1e6D3mToVqVQmSHhL30wZwwYUisUcJ0Ndv4mYM78Guu5iqXcOeJUbBwGNIpgH03ilFUeuu3oYJTZ0VguIP7OmFQLJrWJT+z7iO/CIexxVpQHv6SQ9YJlcTewAmhn0PmWX2iQ++Zcjbg46/EIgq6NY21OD9itR82M3GwhjkSiaidO97PReAhOr7xQIm1+wsNkoWRM8YmC29RVdkD2X6Ncj8ljFmy7hyCbYNt//mEK302WIx1fgRx1R5UMtcSwUoJq1fi0Tz1qEcCTtCHmd41NBIp
 Lji8H0p+
 KMq4glsiVxNcDf4XhCBs+4OcqmHsFTxxl4LEpIi7OV5Q1RIxm7aCoimqaJRgQg2t80MYVOvkcaIRVKW8u0+h95eQ1v5cIQjJHL/WFNHVk3kNuGQdfe8qt6ieB3i43tzPBRTPYRdjbOQV+pIRyiBJLGSgATeJG7ahRakrVeTu9mELzQjC+knJXMnCfQKUaMyMPQNaLwbYaiSTVxrpb2EYLalQYjVPkXsHFspfjjPEdTe3H4kh8gaB3naQItrpnK7IfnxW8IyFyI2+YT/wYFlZj0r46A/zeYzV7AChw4HaC1n98sRwgRJBlRIrNckMVReiQ68+j17vkcvzFe39MfT1k/9URFXeWLW26LEG2kReAhUIVtIZIoAujpD3bTwcuGNqIQEMrwFtmcj9HBr3lgqHxc7PmZNOPgzD+pQWFR5sI/MCP1kqnWYtd1kAanef/GCSUsBXh0V9u1TqW+Fh60ZHfWsHzwBdq2JfuLYx8fmhQGTd91HuMMSsktqlsIX+v9Yq9XKeTvM8zpUPr6QCNq2CEHCD+goHIW2pjQB6Ck7oBLEZVNyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 10:12:19 +0200 Michal Hocko <mhocko@suse.com> wrote:

> Are you aware of a similar work in this area by Joshua
> https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/T/#u?
> We owe Joshua review feedback for quite some time but if I have to be
> honest the most impeding factor on my end is that I am not really
> convinced tier aware controlling is the right direction. I have
> expressed some concerns on one of the earlier proposal by Joshua
> https://lore.kernel.org/all/aZ2LC0KPF0xsAwAL@tiehlicka/T/#u
> 
> In any way it would be great to talk and compare your approaches see
> where they align and the discuss further.

Hi Michal,

I hope you have been doing well! Maybe this is a good opportunity to
squash concerns about the series : -) I've sent a new version which
addresses a lot of the concerns that David Hildenbrand had previously
brought up [1]. This implementation is as transparent as can be to the
user. I hope that this makes sense to you! 

IIRC you had some concerns about getting the interface right the first
time we introduce this feature. Hopefully with no user-visible features
(and only a mount option) your concerns there are resolved and hopefully
we can work to figure out what remaining concerns there are.

Thank you as always for your time. I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

