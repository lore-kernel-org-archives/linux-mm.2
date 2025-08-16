Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC485CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4584C6B03A6; Sat, 16 Aug 2025 10:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406C56B03A7; Sat, 16 Aug 2025 10:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6986B03A9; Sat, 16 Aug 2025 10:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160CA6B03A6
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:12:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3E14140451
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:12:36 +0000 (UTC)
X-FDA: 83782811112.30.DE87E76
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4BB31C000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:12:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f3/Z190t";
	spf=pass (imf21.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755353554; a=rsa-sha256;
	cv=none;
	b=tGFHHstQ/whNy4+CSNpOgA+lx4HGJLXEVQYKIADTYXYHV9lQ19vqceDC0rKZBywlWeY48x
	M3a4T5verLa2nNzGQw8tzG/4ei3j4vGpolO+dTIQTGcvn1YElw4Ii2dfIBTV0UsIQeDmJV
	OpERbuMj2xVJ3TWNLFaXtNlMH+vJUZ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f3/Z190t";
	spf=pass (imf21.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755353554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feoSPjnrOdX0//SvROhIkB9I3UqFW46Ajumc7uAoMRI=;
	b=xamAGwE06FBKN2i5jSpyeD+ptMtfDU4xlqJ+o3MldY9Hb9+tGHOMH8y6tHGcZkjOhFFWqR
	x17bXptO6AYhU1gEpYnEY750Gx5ufTF83nc6BrZRY5W7VKusR7y99UvUFu6ocmeXxDuMDg
	xUCTNAvwc4ss4Kp7yEb4bAn5rYQ+sR8=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6197efa570eso1312994a12.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755353553; x=1755958353; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=feoSPjnrOdX0//SvROhIkB9I3UqFW46Ajumc7uAoMRI=;
        b=f3/Z190t+niYHrJxieAGCoiB3Ig9mmTeG+Q+Bq+R8H7xZza+xxjSQvr4fhAivqGUru
         bXiGhKFST61n7XKNL6SVAzxPlJK8r285FHQwYc5Kv7DyUVkgeoK2o6fG7xpgKKa/bBlt
         Usq4TlgjJWnhH+uSK2lLby4DjEYJISyRdZWd3Zw+agRW/dCdLD171FXDGrUuD+iuFmgj
         vgViuhkxQW4+iraj7m7PQ3280tzmBEVsuH9xMUzhn1rU/svQ+8WdAcvPz1MBzFbn/1Fp
         xc1ckzr3Qu22Cxac13nwNTO1IiVbkOUAHTakzrAAIG1Fg5NjRXG+/GxF+CiCYJ1urgu4
         9B0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755353553; x=1755958353;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=feoSPjnrOdX0//SvROhIkB9I3UqFW46Ajumc7uAoMRI=;
        b=ZToBa7Qi/xfUXPeLWNj2xchnIYe0FSMumAZbPlJMDRlKGX7veOZPuSi7vNSoTbFd4A
         PzDmmg+1+j73xE5scx6T2eUBF6407oiHf3o0Q8+wqtZQ3jJXQjFcVVM25531ltl2n4dd
         4oL/+8dSWZLQouFnPAF+bqPyVE/pY2yumhT718S6BT7z76ZIrvTHw64oYoqz+HLlJxgT
         AZ17vQGlQWjkrEfBRzYtoBSSQsuESEvRk+Mj7DgNdMjORPXBYnkxS7FpeWLpht6Aj4Ik
         v9t7frFNdw8QhBZbjImtCma1H83/VkdTFyhc3sWWPJS23aJVOsPVLup2gZ/gOMA0ijNW
         1jkw==
X-Forwarded-Encrypted: i=1; AJvYcCXDuCirGPGLI0Pbexd7YN5s+ezAI9UejSnmSJlPtSo1VMOg4lDAldoRThqNeKOKxOtzL+ZKuVe16w==@kvack.org
X-Gm-Message-State: AOJu0YwwH+fhDteRsNgmtYhU3r63awNtxgX+M7Tua09etESglTiohOcu
	jAYUOrpeIk71pR9Xf98/ZLx1+LoSt0LOS6jqeG+73WzG98gNWvkFcibr+8rTGYQqEZ7kZqzgjv4
	NvxbkCzHILdtNn5U7PTUv+/3CJzy8Zg==
X-Gm-Gg: ASbGncvT4avuvuXZmFRCC1AgwoTqkpEpeGmbFg93NTdB+o31QXzVw+nJ4WMo754xAWh
	jEdClu3hqGQdBU9J7P7nnaxaorWXxIxKsKPy/DbVUfsGhGfOQ28/Tmh+XheLSI/Uh25uwGXC9Wd
	ThT++lKe4XlEEjRXt0iKJlnzlWla02p8wAPzuxwSjeB3K7WMsbtVRzk7vAUZ7PHRObl/cIopCPa
	tpIjLI=
X-Google-Smtp-Source: AGHT+IF39sA2/AVBMFINcOLAmtFs2hW/T/K1I1gQxZpjqQbWUrpFsMrEH1JB5BTTlUPFahsCPdZqX+kgleQP4aRgk+c=
X-Received: by 2002:a05:6402:35c3:b0:606:ebd9:c58b with SMTP id
 4fb4d7f45d1cf-619b6f65d97mr2325294a12.1.1755353553120; Sat, 16 Aug 2025
 07:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250501163827.2598-1-ujwal.kundur@gmail.com> <20250702152057.4067-1-ujwal.kundur@gmail.com>
 <aGf_W_ZgIf63dmAz@x1.local> <CALkFLLJua-LeS+S5GpiXORA-3wNSR0DTzbh2bvU=Vg-Uzd2VFA@mail.gmail.com>
 <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com> <DC19N1YGQP7J.1MH8WV5KHUHFF@google.com>
In-Reply-To: <DC19N1YGQP7J.1MH8WV5KHUHFF@google.com>
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Date: Sat, 16 Aug 2025 19:42:20 +0530
X-Gm-Features: Ac12FXyvzVN6lhXuryFknwNkw_NPGtcXZDTU-i8PRTDQZLOHQyctkouzXjWB6_Y
Message-ID: <CALkFLLKmjj=Gt8g2Y-2u28HEkoXXF5cFG=v1cV2MEDHjZ=0OgA@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
To: Brendan Jackman <jackmanb@google.com>
Cc: Peter Xu <peterx@redhat.com>, akpm@linux-foundation.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4BB31C000C
X-Stat-Signature: jksugpsh5orz46i9wx6guoewrmtmiw4m
X-Rspam-User: 
X-HE-Tag: 1755353554-849512
X-HE-Meta: U2FsdGVkX19CTXl2CEDPYVXN1SgKyhP8CGSOz9tyoMtEnpL2d/T+nvKf1Al+W3I8C9hwQwgp2qbOWigMcjenVUqI0irUAJye8y/i9Mz1WYRLlF7o8bgaE+21ZnZgUP7wy5xTPVBl2xN3Fhl8M2DolKC24XeVjm+fXbEE09LmgIldXhzpat+S5kz/fNnPSh9oThu8ODRCi8Yw1R3XM7v35UOfVnXicwKgNXh9WOU2KyzTiQqHMGXvoeXB8CgvbmOA69Ju7u/XGdOdCGRiVtPENBiReYbGitkZGxc0zHyzD2b1qWHN4KpWS5kJw/WF2VaPax7qMUYnxhncuJStqhW/vvzNtaLqCfQGp2y9cVDtf/v2+UkRPkN/zsRJdT1+nOpYMub+4xInhBURihTkUYDSyqgdktjcLUruJhrZCmhzHNMaeJCYkKDaLjJL3Zr5DQnF2b0t0ePnigpDwAYaRs1QUdZdlLY/4HGvE2daaLv5+k8cho7MQOlwMfqJUZ0wneYgnDwbaVMl7HxbLeuLzzmpGJM3TDLY7IKFtIWn/QUK4VuHIpswmoFj3SYajJegEuaRc6vmOTaNk6bIkfkwO7HVk+2XTpj6hyE+IkDFafeOfM7eCwBGVQX4JjOJbLv1fvMOn7enMhGtsgNg9sn3oeQqk9/AxhyNi37r867l2yD0iI4EWx/tKpcCm7RYnP9obG5s18MLpdjmAp571R1hzIiEyznvwKuz3ttua0iGXLbALciQRfDgkptpCELWfUhB6B7YHmZiON1xKLRUGuVH1Mws9pkcCZSnY4fF1fNHNIESrhWZhgnLooKTIbk0hJzMYMBQ4hhdafwv+Ij/w00MvLr3mf3pmdSBscaDx837oe8dsIpOFrcJjtZMIfeFfb9hYa89mzqcSr3gL7CTntkzl++KUy9bwExVCpdyteAaJWlHi19B+bTWAyDG/eEXzkB2ojutjtJdWNIhl6GY3/RnGyT
 30W2qJDa
 JD2XDrl6SeZO14F0rgtbEpeAgCQlna8MV+SqLel/I6KQ44ucyaazackt2kEFtY62euOHM06AC0ooMuvYKKxqVfTrMX2MmFUpwXmwRG1VwHq4ZuL41cXY8wMGzRYhNsLjuoTtwBkNY4udepA6BX7VqrrV9LCkEb/MK0qnQiHFXJaORn1vK/Q4jWWX44IcaETMip0EYn4Qlc+ls5lMFluDhX1pBVoCv4WQut9beBRkTipngj9m5ZRcByqScxuw2PqFF7eOLepJ2uS/Ba2h/90KdYryEh4bdA8SKPdNVKEL6ThkrrlgdnqHckA6bzK0FGCysNipvJlRI7jykDzPiw4Lvgnq5fcwgT8kycPPqc51kliWHcRq2eXGvTJQPTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hey sorry I've been on a nice long holiday but I can take a look at this
> soon. Just need to get out from under my other review snowdrift first!

Thanks! I'll have to rebase on mm-new again after the 6.17-rc1
changes. Will push a V7 out soon, this time without threading the
patch as suggested :)

