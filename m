Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB634D7496B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E06E6B008A; Fri, 19 Dec 2025 04:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38ED66B008C; Fri, 19 Dec 2025 04:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CBA6B0092; Fri, 19 Dec 2025 04:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 154136B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:28:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD2228AE90
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:28:39 +0000 (UTC)
X-FDA: 84235695558.21.A634DD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6045F180003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:28:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LjAxv8kq;
	spf=pass (imf24.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7haCuyhI51FS9KbOrG4WJkMhKxZs4nFFL4lqUWoH9E=;
	b=NSwHjhQlz7GgD4ShqEm5GW61/L5Pq4JyHST+i0xx/ZKXLovmHBcSLr0/1F6zA2aZE6dZT4
	UKNEsuHjmJWZ/D5d5MOddijTzTftVMEUMsYknpS5cCTijX8c5r0qCm7giQOcOhRS4Gcwau
	jKfIjeALomsO2aDlJ1AqfJP/nLqGNik=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LjAxv8kq;
	spf=pass (imf24.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136517; a=rsa-sha256;
	cv=none;
	b=f3WmHptKO42UQTR/3JUJ7nZtdWh/bRfqZ0I9MVc0uFSWW9gY9PiA5WPHc1/MdhYOjyoSX5
	Up39pIBDaggVeXQkwVAfH0yvo5GxOPkyoUh8YnUex9JGZ7lFqz5aRCD+xEbBxPyYpE+csO
	czYNGf5oyurowRvL881sWSicsiSmczM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766136516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7haCuyhI51FS9KbOrG4WJkMhKxZs4nFFL4lqUWoH9E=;
	b=LjAxv8kqhP9eQdenHSney+K/i7o+b5o4T8LtE6CDP6GpEe8b+iG6O+F0KNU/nCHB0hP+vP
	m7qyvYI3gRqL6CtpNz/HYT0OMoikA1ojnOk7fSORCLJZ3fwKSctEjZYEgO0gjepyehzfE9
	otQe0BuA1sG86jzWy/mNLvUoh2VRwZs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-faBhfKSKO6yG2e7HgFWE6w-1; Fri, 19 Dec 2025 04:28:35 -0500
X-MC-Unique: faBhfKSKO6yG2e7HgFWE6w-1
X-Mimecast-MFC-AGG-ID: faBhfKSKO6yG2e7HgFWE6w_1766136514
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso14910805e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136514; x=1766741314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H7haCuyhI51FS9KbOrG4WJkMhKxZs4nFFL4lqUWoH9E=;
        b=uZnUpCYUjmxQlrVt+tW/QPTGzPh1Ftee46bvrNNKrq1BuLIbJW+AqSiyyaa49LssAR
         8y9lMdu9xYw4viNSKKGAH7eI5ZPbnxPz90JQsL8vmZiA+bKa/ab996M0x0XlkAW6KO4y
         Ln+2V8GatjUGkrlAyIoUCcK3QDZat8iSa/Zk8fF3nSUY7wCFfx5TaflU7zwbBt0gxABd
         2H5kEu/ynklkRIYFXiUFoBRub/CtJmOkhYK7Ojw3kzkzSySg+WP7w0lH0ad/S/y2lJ7+
         oKxS8nwvz6S++lSdWvL45iaWXIp87TWIiuQFxkUHBdPG9zbOMBTGoy2muzdcnCXFvhXs
         nYGw==
X-Forwarded-Encrypted: i=1; AJvYcCXMkhIMagUkfYn7z5ui8gbrjVNX/3JcbQvS7gXJf8pURK4wkei07iRMDkX3s3o2uYLftCVoy0C2bg==@kvack.org
X-Gm-Message-State: AOJu0YxOCn/H3vozGitxm+8h63hC/HZMPHNxh7/HRNFFdFRKPKtq4WU+
	qCCiVFNsWfT6fGUYrHTl/ZnILFPXWH8iBbyI4IQywC/o2j7JivT1rrcFXTMZjYm3GRZ7T9oZPZ1
	4XoGH+eIawXr4IF3AC/BPUf3W8KBKUGgfBlRe7uM5neHy4hmpgB3E
X-Gm-Gg: AY/fxX50wLggGa4La2lFpNJ+Y6hVAqsXJIKw8Mxq0IbzFRrfyi6UCMn/y1G9vvOUXq9
	r4zoX1GrVQhOVeIbmIm+WiAHgDQklGE7cl+5EGD0WBeWIyTfqCWm1mKfyR+6g3CLgYVUKv/BQyR
	a+hd5Sx5mGIwlEr2ByhyqGcaJ5FIf7KG0MGgcIS0UpiiXUCrlsK432E9maKABwT8SbPa3FAgFyc
	px1AsM2OomntBwMdm89it41mOZEBhuD/gbBxS8hjRAkn/sdiE9WpAR6+xg2KTbVhk3bXR/o7f+l
	0VJLjdBOItPRCKpL0xQ0pgShF4LSQKtjkJSD8HptG9oAHwM/0XmYtvkM9XYRBCtb80r5lWbP5L/
	hJKfQGLJCjWk9
X-Received: by 2002:a05:600c:8107:b0:477:6374:6347 with SMTP id 5b1f17b1804b1-47d19594ce3mr17951195e9.22.1766136514137;
        Fri, 19 Dec 2025 01:28:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNoLKZcFi3Edz90O7ZAZd0UW0hmk7eXl1jBJlmWTqebq88oohMnYaPL71A6ehr5HyEB8Y1LQ==
X-Received: by 2002:a05:600c:8107:b0:477:6374:6347 with SMTP id 5b1f17b1804b1-47d19594ce3mr17950875e9.22.1766136513687;
        Fri, 19 Dec 2025 01:28:33 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19352306sm34590835e9.5.2025.12.19.01.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 01:28:33 -0800 (PST)
Message-ID: <1491a7c7-3ff8-4aea-a6ee-4950f65c756f@redhat.com>
Date: Fri, 19 Dec 2025 10:28:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] sysctl: Remove unused ctl_table forward declarations
To: Joel Granados <joel.granados@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Petr Mladek <pmladek@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, John Ogness
 <john.ogness@linutronix.de>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <20251217-jag-sysctl_fw_decl-v2-1-d917a73635bc@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251217-jag-sysctl_fw_decl-v2-1-d917a73635bc@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6AvqvNWt-XJIheMRtsOrZ4y2qP2vUO3oqyNStQyQBPY_1766136514
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6045F180003
X-Stat-Signature: 5stzhpjzhr31auyq4mjgkga67axq44h3
X-HE-Tag: 1766136517-754345
X-HE-Meta: U2FsdGVkX18ctgCzFxnvCbKGeYRYjgD/upP9mKzJCZnpyAJGnEhZ1NudENVuLf38agXFkVZR0FyLh64N5VuPRE6wuYeod50Y64Mc3q31/HK0PCxbODQcP22sRkK14aOhIlC1u77M1H1bxPC5q0bT72I/aW3ApXfydfhYo4O9xtBn3nU6n21wIbyogylyEsrlS7Ag6BD2DTW8PUkQIcwA4GhuTvZ3TsDpVsis4B7h4ccIeD2d89pmjGbXhkFGSuYZpdojSiespszuXwvF+upEHVYEDZ5JEY5xLzqZCTGMIxWQLW1W7aJYWWUVB0pvFDlVDVX35cldBU8Mb7uU7TQyQO3fSPOKVMkemYVwJyOlWN5f16O/WCxrDxVQQwUx2RQhGZk/5vixiJyxguOaB8LnpakHf3oEtdrN9I0Gp4DCJH2NQBvyQ4njwwo0e/B13vL+xlfYorkZMhqPXQr9A20iyM8ZZrtuiNc1wSM023VY97aLX0OGptKFlLcOyNSVQSBBTGa6o/ka5B0iWGF48CofxtFG/is2l4e/qTJYqkt6mjJVpeJ/AUKV2BxTt14zPiwj0k4b2za1IV38NJs6yhKkT6hEcyd1Ihwiq1uplXb3zyBIgU62EL26UP2AIQiP8zLeDQLrahs/wmUm/DO1SfJkdjUc2uLRjLpN9LTQO6LVmcv9MVuRRZiVjeefC6bjUH8y9x16aies+9VXLeND8w84ghFZi1CXLVijUFddjigL4zi+MC94xOv/ZEJoQ6QfUhfVkaeThlzdYE/DGiQsk2gWgqGaG7zqcSA5PUHOz01Ag2SWeZ9bODNwg5hs8Ul5GfEmcsq00DdzzpS/N2hEe7krs0JMVPOgPV81mjLKPkSmtgb7yv57PWC9zFKpMFGo3JJ0uYQqqjZNAJteHihdWqM2zF5jQdi8g1yn/c4qj4O4Wd/XXyf56Ar2bzQDzwnsyl+bRIuTU5fdNyAQ+kcXKl9
 kH0fdR+j
 0QSBVswD7QJgq5k1lxPjvhNwYaEL0k/1NXYRS81NGwkybTaLNxikUSjMyi2braP98S1hORIqfVDVUmEiIZbSlQx+IIgzhd+ccm8QBaeEQIW1/Ov+HFDTnWq6QYrWJhUlAuFDzxz6zFhfAqfwy0FNcOVqETZVpziTGYrWELlRekjFXxclDgnDjk3PK1f1/lNyEYHvW987awcnvJqByA/No32GNPrE9GH/lumxwoweQ3O6XwgpTDYustd7LLA8bBA6lI4fbbp1ILdp8IMuVquQPd/yf+E2GMstN/keqtx3XqKqke1H4RjSAqdsW2ysEsqqrAaSMK+wum3M6Je4z+MkgtpYGg3eBJkD5VH7KP9bnS0vf8srbSk97bg9ecqk419GRGHSO7xTAeVltNmNHWNjG37i67ycuzj0QUeBlGiTr5GKZDn9p8qAJ3yc/oNMdQHeusv8B4Rp5BQsG8RC6LApW6BW3cb2029Q0+Fl+bJ6gyI50/J+8vnGYcRb+ATpYP4vA02WnM7BAqOPcbqDVxLyxP3CsUpseBy7d8PGB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 1:16 PM, Joel Granados wrote:
> Remove superfluous forward declarations of ctl_table from header files
> where they are no longer needed. These declarations were left behind
> after sysctl code refactoring and cleanup.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Joel Granados <joel.granados@kernel.org>
> ---
> Apologies for such a big To: list. My idea is for this to go into
> mainline through sysctl; get back to me if you prefer otherwise. On the
> off chance that this has a V3, let me know if you want to be removed
> from the To and I'll make that happen

For the net bits:

Acked-by: Paolo Abeni <pabeni@redhat.com>

I'm ok with merging this via the sysctl tree, given that we don't see
much action happening in the ax25 header (and very low chances of
conflicts). But I would be also ok if you would split this into multiple
patches, one for each affected subsystem.

/P



