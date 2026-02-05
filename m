Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700FCEC1EA9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA07B6B0096; Thu,  5 Feb 2026 07:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74EE6B0098; Thu,  5 Feb 2026 07:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76DE6B0099; Thu,  5 Feb 2026 07:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2A356B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:07:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7328C1B15F2
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:34 +0000 (UTC)
X-FDA: 84410278428.15.5B33E0E
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id B429012000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QLHuC5Hm;
	spf=pass (imf29.hostedemail.com: domain of 3A4iEaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3A4iEaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiRDpPfBdhyz5wlzzzVx6PwkN51eGtr6n3cy1jg4OEU=;
	b=uuIYCk55Rldos770oIhgs5Ah74MknBCb7v/06VUvtivzWI2cUcLsTCxGXrOD31tgQ485PE
	zHsrfrqKaJ8H/uiHBwER1gt8Oqjsjijre17NTHOHk3PXKbWH+T74r0DilXb0CxTp95E1k2
	+sFSmKz7HkuLh9cLG7+KWt58Z5ug/GY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QLHuC5Hm;
	spf=pass (imf29.hostedemail.com: domain of 3A4iEaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3A4iEaQkKCHgWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293252; a=rsa-sha256;
	cv=none;
	b=ihjOVaVLp/GoIuaxg+TS4ABBBm/b0fPpTxqp7EmRtxpjrKt6WNbhV3HV1twtq7v5+owMlF
	7lxAZ/EvF8Gco1iGdCTrgEZRDdhs3giQN4wAHxfzmYOh6WWOaqU8eFYEKFzEjb2wfzdNyO
	IG4qnv6p23zqBn+Ud3XgvLeGMHkB7mU=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42fdbba545fso1754303f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770293251; x=1770898051; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AiRDpPfBdhyz5wlzzzVx6PwkN51eGtr6n3cy1jg4OEU=;
        b=QLHuC5HmrzbN1x8wh57+hkLkCrm3COsq9G7sBMgm/jdMrT3pssvRqmM+fsZzILcPjK
         LGPY1I5nsVQ4jn0tFbTj4fo/m+H1BwiA/01cYiqNNH8bbFywmvkw+DMcnQ7OCJ4QAPhR
         1NHxnHCrYj6o5zLX+/ityCGzJTBZosQb6e4TVXHt1EgW1ifcJRWQaipNjTZy71rBOLZF
         TMXnmXHMw8sI+or3zP1gRcP8XIh/y5VgBK5PFa8cMROPdoCIHiZTf3jJIVAT/QcnEdRX
         TFUaZTfp8YFddp/02Pgfme/FE/noCI7gIarnSRczhSfEyaOhabUZns6tROBK4gXYnDn8
         blBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770293251; x=1770898051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AiRDpPfBdhyz5wlzzzVx6PwkN51eGtr6n3cy1jg4OEU=;
        b=gHIKgqsp8Db8D+HlhzpvkXUzrwcfqWMINydr4WP9DCKjS6ofPrTCQTOtgfOShmykAX
         /L0gt6PviUFpN3UbX5BvzPhECUfbBeVErjfopGI9k0a6pilOvumPMkh/7T1xMjXBuP/C
         uY4LtAioDflORDQcOXvRQmSGnNz4RgL4f4BkAJzUk3wutYsS3Ypd4X2ysKeEfNPsD5c+
         5GvthnJCqHTkqF6BROuET8LrC3S+EsBdjR4yI4dOzpn7uQ0a8omVTt18zsFFgs6+Mihq
         NndaPIJZDxYqTMv9CmSbMO6dPTkjYgVecJ7B+K97xSzMqDj9zq/DwMpH1llYO5rhRpjx
         DCWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKANht+djaXDvVx6kwAIZYFiZOCbx7BYAjDEGVIk3fp5yAfmcjjZ8jyz8g+FlHsHT2VtJeArwt0g==@kvack.org
X-Gm-Message-State: AOJu0YwNmVp/xW2nFvo8YTwielZ7TbRGtXqpYaCeNiksAdfCzMXHTCfT
	/ybNmVn6uRa6r0qGmdhOZOW7cHruLrjorqSojY+y5tZP0y5G9UigsH75UYb/PjEHBDgrBMAMCJD
	FItC3W90WRou+BxmzwA==
X-Received: from wrbbs27.prod.google.com ([2002:a05:6000:71b:b0:435:c29b:f782])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4201:b0:435:a135:777d with SMTP id ffacd0b85a97d-436213d7b3amr4150152f8f.9.1770293251034;
 Thu, 05 Feb 2026 04:07:31 -0800 (PST)
Date: Thu, 5 Feb 2026 12:07:30 +0000
In-Reply-To: <luj2ggjo47mvjzhzavoy72ro6kaoj46cicudjrc6646vs3s7q5@wzc7aabgdlkl>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-1-dfc947c35d35@google.com> <20260205-mitschnitt-pfirsich-148a5026fc36@brauner>
 <luj2ggjo47mvjzhzavoy72ro6kaoj46cicudjrc6646vs3s7q5@wzc7aabgdlkl>
Message-ID: <aYSIAoK5KkZ3ver5@google.com>
Subject: Re: [PATCH 1/5] export file_close_fd and task_work_add
From: Alice Ryhl <aliceryhl@google.com>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 73zbupmzfwdoenadzsuktj7otfk9yf99
X-Rspamd-Queue-Id: B429012000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770293252-802702
X-HE-Meta: U2FsdGVkX1+/QAA3Ob+UWE9c9eVrbgT5heMZ7yYMRQur6AsL/Vjcj13NsheBiNlBHtlcr+jAar5/tA5SUOAKoCIm59O+560GARP5CAbVoMu+ayKCKeXxYxzEyn9v/Lmb2nwYZ9aJcIA7szMT1dRxbg+V3qlhyKXFL3733h6wSf8DP0DgiVWDJJihwdZttlPHZsWB2J5lTtQO1CUcLuitAiIQJsI/pbPe3aOJjXnUNt8vJEgoiORlpihbaL398pnevIm3M+W2AGCvEIGQv0B7mJlQe4l1m8PWS9QoxS9Ny7xrhym0Ls3d8wo8vQfdlqJ59JIcBhjPEqaN6Ic/DTHm6FDOI6T7sRtLjrpie1w0Vs45yHg3MGKqA/IH02/k6DcRcBd53Wuoyh1E31fkQs14CmvoJW/cG6iYR6TgfJcerkUf2i1t1/BtqYhZ2/cISTOCSvEkPrJUCjoQQ8CXrwHwsYgVQxUrOnxmvDpg3Ua6zIYQ6yHc6UJnz7LzyWsG7YaBSx00b5ogxsD527CeK9WpuuGp7Rk1BYQGgY5MzBPq4YkRTqnWEQyblKNVocjB6lhezNbhITltjcsToYsbVMRFsj/E5qvhuSnyoYrNfSqaIFJHi6N18YTZeWn1PmmjTdlWFrH4HvOs+P21NqhM0ALeBPRssyDijttsH5/RJAJAZK+MpoPC4fyVLcFg3QLdqwHHFmGHclEpT0OhTaN1BBxQU96pXXkIBtYC7bGvGg7P+Kn9SNUzXqCBbPkm/mmxdchxHgXPq16oy/Ft5n74tfvrMRt1YSdRW7XgV55YomGI0JPJFKnEnsICHAeCgulRYQGwqwV4o3C94eeeE8pTGhvzRj7KAWjJxlmiSFM6CH1uAdjg7pqfWYa0Z+2ax6iV1BwsIQvAGAlQFPG4omtOTvn4NCTcZwv64XTQ0s7lBmaYF2rXcoony48mFUfJCvx3UzlOja5kw3N10gaBxIAxHMu
 O0o2PHEs
 c08Ab4P7gnXsdVtIPI1YUIk3wCdzWwK4jST6JHPC8BM5rE95N09K4uh4aikUzc/jmT4edABmVxIZOaX5zaE+vsWTk9f8RcYn7E5baKzdlT1rdQ7o7BY8kUqNJD1b6jkn7iK8JbGGKnxDAKn5GtXeuNADSKtc2s7kUoI3FXwcjUZX3YQINuyBGrzLxWoV4f2dNsYJLOgCY/4J14FkH3zByMJQK213aQ4XGQZmwGKbehDrd/Hf1DqtzMgO/ZFNpX9iUuwaqydMG7eeE9cWIlLgCkQJerx8dpJT32H9myj7yeAwftMIYfqin2lZY07Nqf8ZDJb8q4r0BA8gBZrFWeF6rxbNeaVHyi6tKPHOfhkhUDMseEWlJNOKYMLu8djdu2AOHfM+MlFeotg2O7Rr0641v9WoKdsA/T2pKUObOoQj2gZz1FkCH5ifAB4tm4xPlixmJ4gOXJq/WVKbplUEveF1RvLaiXAgD0a5j1YnvRRXkIiynaJn2ywDlHPQE+IU8gCI/WK4/XckIlftJ5HxYS2b3Kw/W0wzGNDkWgz1HMwyeUYJBMMc9zOuxHB8t4ADCsQWfQSBgmFLTt+Mhs30OljpMirz8M60R+U4b2nvdZMrXzqiFpWk7khXEHb6E2wjbEQH/g8YlIQLw64iDb4d7JGAz55E/0tra+dMN9BL7ylbBL5kVlRS5DslJCqkvjRrBVlCw1g2yttQlVpURQ4msxBJav+VnAt+0kAWUrJpMsTtvX09JI0OPtHtXxO5xKHgVSKorS5WxLaZSE5AkVE3oHV+5w0cN6gndUMo+8GmW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:52:37PM +0100, Jan Kara wrote:
> 
> Agreed. And just to demonstrate the point binder's use would become the
> first of such bugs because it is prone to the module being removed while
> the task work is in flight and thus do_close_fd() code can be freed by the
> time it gets executed.

Good point ...

> Generally, making some code modular usually requires more effort than just
> flipping the Kconfig to tristate. You usually need to make sure all objects
> and queued work is flushed before the module can be removed. Not sure how
> much of this is taken care of by Rust though...
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

