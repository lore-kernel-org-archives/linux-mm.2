Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FD6606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TPqVA1RC
Received: by kanga.kvack.org (Postfix)
	id CBAA76B0B49; Fri, 23 Oct 2026 07:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C433A6B0B4A; Fri, 23 Oct 2026 07:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BBF6B0B4B; Fri, 23 Oct 2026 07:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87BE56B0B49
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:53:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 877C71203C5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:53:34 +0000 (UTC)
X-FDA: 85353731148.10.54B67F0
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id C483A80006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:53:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPqVA1RC;
	spf=pass (imf02.hostedemail.com: domain of 3ukrbagkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3ukrbagkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792756412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLj6FN5zzpYaXQgmzegMg+GrSB746kgYZ/YLy03P7lg=;
	b=xsRe26v8SLWZti4nZ/hgbei5ANiUqnG2VOl/DFCum5cXcg9w7B/di1LDCGFE+uoq8/Wicm
	jTMTx8QgEt3ZqxfxqJDJeHzrYYzMcLZsOy0rN3f24FUR7QU+fHNz+ieHVrPVILBS07LhJz
	/wn58V2zhPVZbaFvAbA4l5tRV78J8FM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792756412;
	b=wOpHqCzvzDT8hTKW1jl5V+WnPQq9ZAjrcUF0a4mXUFn6jQRjbwsAO3CyRo752XG+bfmDd8
	HhMUdZY55LY/oGBoKJ9os45SjJCLEXRO7WYUs1MaAdaS8yAEcndZrfeiiFBzitSxkpHYt+
	uS0BSgFrnJzUqsRhUS8acAtZRQzSYpY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPqVA1RC;
	spf=pass (imf02.hostedemail.com: domain of 3ukrbagkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3ukrbagkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a21053899aso4910225e9.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792756411; x=1793361211; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uLj6FN5zzpYaXQgmzegMg+GrSB746kgYZ/YLy03P7lg=;
        b=TPqVA1RCGwfGs312e4xWwCqmLD+LxTY0fXv5KydZdvBkPK2PzMhxis/N8wJzFY6j9d
         gKuGCO+2gl8h2opqPqT7LWavvBq4b0J40W9WGFBRSjYQ6tkJ5Y1fgCiDRxY52ZXKFUeS
         +OmY56ZHYtrSVMlNtiI6HHMMggVY3AwUaEdDbKmUnWS2UBIiuxlBcv9RzDS2td9KyHLf
         /1RiHWxWm6PEAvlv/NfHJQrhyLrw/Vf0PpUtgFX2zxgISW61jJwmTJsNRHTBpbEAGWNe
         veJwKkg6v57m9qO82MEFPFuTPReBl3fTCmnvkct7gfPU5XBo1s2D5XXx0jhNARmS1XJl
         Jq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792756411; x=1793361211;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLj6FN5zzpYaXQgmzegMg+GrSB746kgYZ/YLy03P7lg=;
        b=b4St09Z8eSaJPTba80bdPpCFPpvxZNJSVPCcXYsvTd7Zc4mU1VLoP8oHoDep3/a/xO
         ZHyQm/8AZO10w4woWV/D/o1jWH6assCkdFxcQg/4Y5F3dBHgHT0Lx1/UwzCqUsUZ+Gfr
         XZBRNZyjf60pTfLqeLJgDT7e5TzleXX/Nlg23kwFJzM4K79CS3sfkEFNlXrKPrr0pMZ1
         GRzqPNBVE6Wg6XssQRQAd+ricOfI4hn9qq5XhFyVib/cLUFpeD0KObXdSniZQldOehqq
         IuULiNA8ExqDNoqo0XEquYByDVD6mvMnHvAV+DcPHXOMbSa3/qVM0HDGQkrNtGDom09f
         tfrQ==
X-Forwarded-Encrypted: i=1; AKwUvBy6R6+r9Uw6P+tvJrXle2AtRGj4hBgpsKLcASojZsSQMi7LuctTI+Kyy23Gl/m+tEWgKsnt7bkbfQ==@kvack.org
X-Gm-Message-State: AFq9FYKPEI87dlpdZmFjyAVRJnyT+jekyMN3XsCRLrdFPez+B7sxT2rO
	vkhS5DGOMTXqo9OxSbVyOxzZeTt2m/NO2TEdQ/a3nzIIMZqyugjTBYRydt0P0vhetdl4zZg+axg
	xqJfXG2qbU8IcqX7zxw==
X-Received: from wmoh19.prod.google.com ([2002:a05:600c:3153:b0:4a1:8915:6ed2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e8a:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a211ee9b8amr34064815e9.12.1792756410725;
 Fri, 23 Oct 2026 04:53:30 -0700 (PDT)
Date: Fri, 23 Oct 2026 11:53:26 +0000
In-Reply-To: <atqh41vrlC4xVtaj@um790>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
 <20261020-tyr-ioctls-v4-2-704de77da223@kylinos.cn> <atqh41vrlC4xVtaj@um790>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023115327.1776353-1-aliceryhl@google.com>
Subject: Re: [PATCH v4 02/11] rust: mm: add `task_size` helper
From: Alice Ryhl <aliceryhl@google.com>
To: Deborah Brouwer <deborah.brouwer@collabora.com>, Ke Sun <sunke@kylinos.cn>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"=?UTF-8?q?Onur=20=C3=96zkan?=" <work@onurozkan.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	dri-devel@lists.freedesktop.org, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C483A80006
X-Stat-Signature: bxdxw4qngofqchnsmymzwotk5u9eurbu
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792756412-218491
X-HE-Meta: U2FsdGVkX1+oWMhzAYPw7zQEgWk3/2b9IV8H7pm2mM2e+JXy+lS/NdNGB/WSavv5SY4t13j8JEskpBZQunoL+EtZCeRhQEz+fcV4GArqq44gbRC8ie9yXShr2Dcc9K5ZDh5sxsyy8AnlmsZdNUgfvGaeXnsVudAdkDiPOZqMVKVU48JNALai3roNjRlP4pSV5lIxhysk56RAEMzgkBRkejbFE7hdQrD9tSS4NwxJdnSgvKKFc2jYMcrc4RTLAmVmtqcOE2Ja7SHc5+USFmFFjv9DzgRuL4kruGnMAS2zGuFt7wBmij/wZ1wpjrg3HMluwb3QzkUgL/oUb+U16z7+oU6+XzSwFQPYWlX4QTK2hxcZVgUv1aD3rsAerlxMTEdJWXbS2wmVTVTJRmcbAxE4pNWRdIH5OLrtjgW7MOz6jhIkkde1d1/3cIb+7bM48KF0bVquM9l5fG/HVlE+KeGLpGFOh7Oq0zyP9216e9IAUCj0ezE0LeOqjprQmwRRwloElHuE1h2f+XNM6GmIVMMhnBwRhxgZiCfIFDQiETh7cQnU8dCMQC6BBGcAW4cpVevrsFLlMlEaI9t81nLFFBCe7acKRcue94trG2wlOCobl0k5hPwFqnLzx2we2pVxqJARHZbWFzFezmiz6kJXfwQcDe7EH+ascvFGAN05b47ORqoHCR0vrEjk4A8Gxy0bRHw54JcpEpGvx5rcDUqI0u5/3d5fIa/0TIPH7YOMoHW3qrbrmMivIb/1e41vLAc571pXdbM2W1E4TjanfNuyjzgJDFZeqIbGy2JK2JuvPpM4BtB8G3T+bXm3WOxNyceiXSE3OiV3ED6doQomb8aFA06AaEhF7/wUD34WuFE4wPz0+OXJXlopN7+hHVn37tRco9I+j+jfgE1sycUNI+LQLgDOSIL2xMwus8TQD57uFmI3hexGHBwIw3iTuhUOX14E99khWlDucCU7yW6Q+QbgMDF
 GLtu1YMx
 bc8AQRGu/vbYbay8/GbzMFtQy5pPrfGE748TZdWbV8+GP+Smaeve1rAZk+aISYAY3R4CJxa0IFLjjY77KydkQP1cIm0mJ97skhUg0VB/cKoHLcTfq0IFvDKY6W4aQIYddu2HqFRXYFeB2R/eX6Vg1F5r4Zyi9Q4aN2Vf6EtWjGFuynjNi5Ya30DJLiPmG8z2Lsi9O0tyFBA4MwBFv6HyCYDs0poDSvKpR94qPXOo1WPpTGVVJTIEuLSUTWLV9T8P9C21YfGRVXDrGyWHPVkDo9Am7ddOlMcTUxFScSKeOv6mkn53CllrdA13lahxfkQcdDvoZAuJfpgHM1jN7dIKTOa5ugGoH9v6YPVvQ9HEABp09kfXobjQCxNVnHIHVSEVG92RJEvCxzZlcHv4DcElM5rJZH2YfN0jG/Hyfo/hijrt18+aWhKwnMmp+aoXNAehVcQMMAfz24rpQX3+5U7SwXwNk4Xw1dO6VBcXj3iUqoUqkEkanDdTVyuG03KiCY/5uUTFvOK6U/PSeSuDyGVTK0m38R4UT2on0i5M990yLD0722IT7WwiwucPXtS6PMCvYwBsl4szZAlrHIcFmjLf6g/1zUpq51ueacij4Ci123mSOsF8M6q5E5ysrWXDVTe6qt3PgdEe7R/otjcA/pNUP9z+NnOm0uy6w07Eg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 04:53:07PM -0700, Deborah Brouwer wrote:
> On Tue, Oct 20, 2026 at 04:25:19PM +0800, Ke Sun wrote:
> > From: Alvin Sun <alvin.sun@linux.dev>
> 
> I was testing Tyr's auto allocation for the user va range,
> and was surprised to see that mm.task_size() is always returning 0.
> It seems like it should work since it uses the task_size from
> struct mm_struct, but it doesn't, at least for me. 
> 
> If you look at tyr-dev, I think it would be better to use Sami's approach:
>   428d71932b6f rust: task: add task_size()
> 
> Sami creates a task_size() method for CurrentTask which is our equivalent
> to the `current` global and then you can see that task_size becomes much
> more clearly the equivalent of "TASK_SIZE_OF" used by panthor.
> 
> This approach also correctly returns a user va range when Tyr has to
> assign it in my tests, so let's switch over.

+1 to switching to CurrentTask::task_size(&self) backed by a C helper
calling TASK_SIZE_OF(current). Please also include `<linux/mm.h>` in
`rust/helpers/task.c`, as on some architectures (e.g. riscv) `TASK_SIZE` is
defined in `<asm/pgtable.h>` rather than `<linux/sched/task.h>`.

Alice

