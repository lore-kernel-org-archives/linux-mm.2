Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFFACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6899001AF; Thu, 14 Aug 2025 13:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96607900172; Thu, 14 Aug 2025 13:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CC09001AF; Thu, 14 Aug 2025 13:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77594900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:12:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 199681A0769
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:12:03 +0000 (UTC)
X-FDA: 83776005726.14.D50A163
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48FF2140003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:12:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvPVWOCY;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755191521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jPB5RNhCbCcAQ6bj3jSC8GzEt+oraETjWNlOpTPSYog=;
	b=NeKMCZ1TuF4reoOWVLqtUIeGYUbjbitu6nREZhwS56y7u2uicgQHwCnJqGA0OeUv4UwU69
	5gcVvYKmAhYhEO/XaVTZ8tsmnEF1+uKuWCgmRSvJHXEkVuKY0EV8wnZYCZPlUPb9qIln1W
	+8v59Fpi+yjSY5KMVxQstolXnuzTF8c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvPVWOCY;
	spf=pass (imf09.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755191521; a=rsa-sha256;
	cv=none;
	b=lKK6bQKlRTjcXyM2bQTEjW3DPQxI/fIU7znjCKDWc24nKWJRT4ze/BS6ZpkmvmvkftKedh
	HUOo3MZzndM3KtIb42+xBkQy4zYTfqVr/i0SWQmssbEZ+9+Csk62p49PWcSPfE0EsAR1dJ
	FLpZBs0Qoq6rtbvHaV52rjHplcE2meQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b005a3bso5734345e9.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755191520; x=1755796320; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jPB5RNhCbCcAQ6bj3jSC8GzEt+oraETjWNlOpTPSYog=;
        b=YvPVWOCYDcrNHHG3/c2aGR5t3BnVWCC9rRHg6zGwZR6hVP6S2OorWFh1A74oa9HvFR
         HtDya2N2FWCpe02a2NIXOhYqfpTpso/C0ethGFBUwbo779nv/CBNB14dfaCa9QRaXbms
         GkGcdGcY/VVwnbHqUbqWDIYrjtxEf+IRmVjIkU68/PJMUQtC0HoST6eqedtE4rKzSAuh
         wXmHn4nKtb6QntKQBXq6bY3+oCpg7/48sMVQFpm3/hBcEkN0vakoBecaPn48lrPi4cgW
         mBW/B3JHZTl7xLl0wp7cfSe5Qtx6jU+NvX100Q1RpTbi6KEM7xcYwqzeBZoE6fwMiMqT
         CXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755191520; x=1755796320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jPB5RNhCbCcAQ6bj3jSC8GzEt+oraETjWNlOpTPSYog=;
        b=dO3WkYSEXyC2EwR8xXql4KUfPc8vWYjEXb4gK5HNeUww27XR5n23NSjnuGJwCEma5l
         ZOlkqHyJAZWSZWTyF/V1XXzlKCDtZoNW3ijnXUaas6c9AYvBywMfbd1OjYh2CDcRT6si
         hTUxSrzW+5av0Jr/Rnbz/H8blCaO1OilOK/gaWy+/3KjXI+ldeCS83WG+IYfGAntbED2
         A4l89RR9KmGzSUlxy+m305Y2PMYrjeI3J+YzzCsklhSFUa9OjZd4ncHnnEeIAoC2avx8
         WuMi7LIMcW2z1Z/oViFuMDmK75NT9VNNqeRzB/G5wwr86kCmIzj9zwtPInRE5S3SCn7q
         ciXg==
X-Gm-Message-State: AOJu0YxJnhV81Y3H9hB/cZ8KDOnCX7mJGahB0ummCLr/s7miNRf0kjVT
	I6lEwRfj4LX/d8V6EpazTvX3uaVTrysoVWyfW+Sp8zGCG0+lAtvKts4b
X-Gm-Gg: ASbGncvgI6uwPDYhug9IojuC7pSX+EtukvuoCIZ/Tazc6vwRZTiZ0d7ViSpsSeK2/57
	N70k2Zl05NWogpxwE1V2WCDMPDiud8SEo/2dVIvt3r/rUm4GRClYV5xhoST4+INLZYKLyP90/qg
	C8ITa4ivygMaag+tCNA3CJED97qNPZ86EhhblIlNKlqh77auhYQwIATbKtoIRk0GakuN9WbyGqE
	TtPLM97e0EHtNZS8Y7M8ck9JqdXh4ZOAW3oAa5GF8q0FTm67rcHXwNYuh/808xM1ZGcGiZZWxxM
	wGl5nctGIhJ03R91QV0Nh6ZnmyfibNLreuJYMljWQoGmNa9PYc5oPgHhmxj/NcPUH/S/7j2SHJf
	N3WtnFv79ts8=
X-Google-Smtp-Source: AGHT+IEiKVW5cysYs6D9PUPlaCXMJp4HJbkFO4bp/Ybcr87V8BvWMNudwkgIyJLcJXX8zmDW65a0Vw==
X-Received: by 2002:a05:600c:468c:b0:459:d709:e59f with SMTP id 5b1f17b1804b1-45a1badbec6mr33517195e9.0.1755191519354;
        Thu, 14 Aug 2025 10:11:59 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c46ee84sm50127252f8f.57.2025.08.14.10.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 10:11:58 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Date: Thu, 14 Aug 2025 10:11:56 -0700
Message-ID: <cover.1755190013.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19g1u4mni9zar4s8hma7ep8iih95uejd
X-Rspam-User: 
X-Rspamd-Queue-Id: 48FF2140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755191521-359990
X-HE-Meta: U2FsdGVkX18j2pkeERXbgth0d+lupB+oDsBKjluHicD+xXKCdAAy5WOJBn7Fl3F1pSkfp5QghssJmMi6yzomJO0PRUoQ+l5BSdnxm6mS67owwLrSnjORWD+iuBkBg3CfyFTQ5GLXjIXM4VdUExo0nsqimZNiMAe5pqxFufKwdeD0Mb898SRi+H3UcjwzhdTPRKixvw+2I4dSJSjU7Vqj9fMgJE8cxs+7jbbAGoPbeHecW4R/YTLlKR1/TY2ArvPsykfbedfbTrY+e3s7XyJu3VZxS5nDsr0nrN0rpqgogAyb0MpGie41xhGXAdCIZZkfLDFjVOwfF6PgnQEJP9BI5E1wZMeapguGo9ZytzpP8PVkFNHK7neErNrALnBQUcUDDuJ7zkLRTk3vnn/yCJRAnoxUNsISPn/WoQ3/xzn0a7H3vzAKCx3q/5bgIJj14LWM5o9QVo8sKqD0jXL1mQ0lgbkWjsvHkaJY8VzP4j1KbH48VahrfqN/5DGgNEtSIFtQ3e25Rhc4zfptAZ6CUQiK31ECW8wX8Yefoujc4d0cpokuFUgXnB+F7Vi5BbbDXNSB3VK1bIIvFDWsF33x9/61b2+o89/9vuzcAxStJfaj7lWT+fiLl3ALLTfpVya1XKRJOwTr5HdoahUt/l2WBKr5sC3VMa9lrLwzzkMRJECeYowdZUiF2z6tUVieeFpB3YXrcJvjj0uidVeLryN0EdPg6TWJjN9e+zblGpF3cSrTyeyACr2iCZMC3WXPEMbWzbiwaIX8ReVu+T6cXOcbs1nHy3luY40Huz+zOy3yLniVTKWzCt260FDzrN/+1cMrZ4uARFDIsSeZ1Jk2304SxOo/0k2s37DtCcHuiPQ4GN8e0rOQYOBvOcABLA/9LRNn+gT0Qfglhg4cMLpxBNAclYUDjTs5a6gRGfmC1wRG94WSuaMgqP+vP5V9vJEGW0kGEcBDn8L6OAp6T6kBAPq9eio
 2sFgCY0Q
 +4W0ouLvAvIIH/PJeKmZsOI5ocbuxAWdnaJ9VBm/O5nFFwt6qNxpqJ4HyhdHn3i5QfUYXw7bXEilZZLNnUvmvRRukNxAC/PDm/XihptWuWAMwXGJr4EnAB8XphuCwpZY92C7ZxlXmTJnnCyBZBnT9qUcBVgJH3+leeHWFcw2m0UuSR3gAOAwkrkX78c7NogcstAtGXDmRd7C7YhdgoBDaF6c+7unnZPerk5pYoAJkuDd+0gtolNSdciM83SLIptimZ5UbtYi2ScjpYD3zHpMLwC5VfaYidTYzH5C8t1RF2CGjHiSejuWshKNnDQ6k9fAhJwqJ9YibGK41mRFw3InWvBZQo3533PdHAF6iiRN3EJbQQrAxjKXJ49ggl3JevK9Izh7zkcH/CC2szKhknbOTZppccoNIhIqSzxM6ys4VGABsBfuGsfetIKag7YJDLkhFYfmEkJzr0Chm2m9731dZOvV4xkO0549JBybtPaJLVzgvDqXEyUoYafw1Qnqe0iZ0Grt2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now in the oom_kill_process if the oom is because of the cgroup 
limit, we won't get memory allocation infomation. In some cases, we 
can have a large cgroup workload running which dominates the machine. 
The reason using cgroup is to leave some resource for system. When this 
cgroup is killed, we would also like to have some memory allocation 
information for the whole server as well. This is reason behind this 
mini change. Is it an acceptable thing to do? Will it be too much 
information for people? I am happy with any suggestions!

Yueyang Pan (1):
  Add memory allocation info for cgroup oom

 mm/oom_kill.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.47.3


