Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E377C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EABE6B0089; Fri,  8 Aug 2025 03:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C056B008A; Fri,  8 Aug 2025 03:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCB86B008C; Fri,  8 Aug 2025 03:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC6466B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:00:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D8AD141514
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:00:42 +0000 (UTC)
X-FDA: 83752692324.29.B723385
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E85280010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:00:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=czWaSu25;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754636440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVEu9GErkIXG3eJ2AqWu2ENhgTXDL/O6jQUo/mg7Ei4=;
	b=E3iZBsgOpN4lHHLLBupJFZJOiYk/su+MbU6E5EvUIyn9heSlh28nctFcE6WfJ7G6Z7GPMD
	NeZ/T8meq2GA/SnAOTXRluls7FVXcYCmcWWEzC7krd3fjCOU4SSYCHi4e5niOXtpLeyUYG
	89Eio542DYklxA1bltOpAvuE6IZ7DRc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=czWaSu25;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754636440; a=rsa-sha256;
	cv=none;
	b=xY3oc7zJlbaYCf5mDYn5ynvUJgGk02039BoDOSehZBnQA/7OLPUkt+Urte+s6juHbmPrwS
	nmFw+U+DjYl9mXnneftelLtqg27+SHM9/U8iQnHdjKvhL+LIpgtQShS0XwEcUnLWo+Q8O6
	5YlcuYbr7IOGFntrOc0vEqNT3uMaoj8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b7892609a5so1077693f8f.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 00:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754636438; x=1755241238; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pVEu9GErkIXG3eJ2AqWu2ENhgTXDL/O6jQUo/mg7Ei4=;
        b=czWaSu25AnOuMAdLtoLB0A91k9zI/9iUN0ELcpew00chaSZFOcsgJ4qT/DcLHsbV9B
         AVUTYy7473KCes325y/+IG+7D96aVu92YKlekjye+p6miNz0vuzdnY5YpvWFqg14Ly9R
         cFFt65h5hTqfSS2jbjAIeGQ8+mu/AbvpxW1glPnJL3Lrm/88Noiu30i4d5pK7QxGG85H
         /VY4PcuE87D4VNpYHzImM8I5SuI8J1DJhBcs9eZ0vjt9mI9+qnHqqOiDxO5ibuRaxavf
         r9veqmswgSjrqWSbzhrkn321/gwl9VvN+zLIjQpYUT72mUlbTUVXYzdpPOG/Z2+RkTXz
         9JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754636438; x=1755241238;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pVEu9GErkIXG3eJ2AqWu2ENhgTXDL/O6jQUo/mg7Ei4=;
        b=QJp6TglRg2ZwEVV3oOczdkH8Sm+AAGQXJf2kj88ePLPS+dfyFf/Uoy8+b2raiOofw6
         4zSc0/EZXYOlMokmVP+BIapm3EQDYjuJm511az1NUGpd7w42LcowciSI3pYtBkXV5y8z
         eKPspaBvyTltzyLsYmBC5XhI8GdD2Wl4cjCZXs0oIl7ST6UKkH8XtlzANra6kBpKK9C7
         ujtze9LbgO05y+FfubusX6fTBV5rtsdq6V+i5OU42/WgcdU6q9pBVGBIVFBBGUPmfnNU
         9EJZ6hZAFpsfCx3g1PpuEo4odyVzC9M+x5/hN0lr5wzjoDzmL8wz67KMjaFA9VTn0elm
         arzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwxLLRsEUuzRAh44VJHybpoDPq0uv8A8c0w4VRe0UN4ra5KO+D5oSoA6XnSjxy0flYtoEvTIZNFQ==@kvack.org
X-Gm-Message-State: AOJu0YxkcHhQ0K6rbhZoYSb9EmVGW82t6oZ5IwAip2P9DVe9WCm/1ui8
	g+t6Or+iGgMnRPXvzfWfRlDAsJz0t8Y0+yFhnCqMG9AFVDyGSVznvGbCX8tWOXb3XG4=
X-Gm-Gg: ASbGnctZbTuZALzvuJc8/ETuzVjFOANbH3cB8v4S4tANPi41EvtP2sesgRitkc+VB4Y
	DjS3zbiHPrDSVXAHiaeXeX1FKNjMwoC9XKohl42HVO62cZTXwzLxZ8IEj4q6XmcyRAPZkijecr3
	c+j01cW7QaNlNXiaRQeZJQI8+rbv7V3NUu9Sifhp0rm5wMu32kEP1zKNMStMqtsB1ATe5E8NKCA
	9DqXKOQci9XMiMkZ7akajryiJxpDlUokMS9WI8HoXlc40nhMyBjuLB8/adOUxseexQa/wffsN6S
	89HiVC0AD6WuEZOuLH5YHirLZufeSIeAm63vk3LhCVVIZlDZfR2lXTevAsAHJj5yMHdXm5igeQ8
	E7t4wIeiX8gAi80R4a+jYjjYp9EyU2Quxd0o=
X-Google-Smtp-Source: AGHT+IEJk4yevy9+HAy0KW8ZE8r8h3He+ydCFV/7Q/AXZWGxTkl97mbZhRDgapiuoxoRlq32dlvmJQ==
X-Received: by 2002:a05:6000:400b:b0:3b7:7cb5:a539 with SMTP id ffacd0b85a97d-3b900b2baa8mr1256578f8f.18.1754636438515;
        Fri, 08 Aug 2025 00:00:38 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e586a011sm133293865e9.19.2025.08.08.00.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 00:00:38 -0700 (PDT)
Date: Fri, 8 Aug 2025 09:00:37 +0200
From: Michal Hocko <mhocko@suse.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <aJWglTo1xpXXEqEM@tiehlicka>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E85280010
X-Rspamd-Server: rspam06
X-Stat-Signature: 6o5sffrrrouo9fsraxfybm5kc6bfjym3
X-HE-Tag: 1754636440-394653
X-HE-Meta: U2FsdGVkX192uHhgTP5MkPvAv2gT2PYgTQV5dGFsv8mGYzVg1wDRNQJCU5oT+ZxADTmT/YXwJcmoB338NgU/4I8ellBaBCWY6Iv5SRhc01KWAZ2Fe8z3Zw/VB97ymurSMg3LTh5EdXNQLa7lOqAQwgp7lGEtA7fLlHKDR7Ot0b06w2akGVgy8Hh//uqWep+cDwabswsoWyckOvTBu7cNaPHVUI/M7hv7zbhoR33r4WF0wVr6W4Rd5v8bnPf+KV+E38p2xX25HJcYH0dDWRsmXKnjdYF6MWdwppb7WGKimOdTQ11RsZiAvysps0qyqdSlZCzJFJrH4CT1lJknpIfYGVU/W2E5pauBkPqzddvDlvPmpihksC4Ac7ywVHh9YDHiv715mckZVFWapmxK54JtzooyojrRigOs9RC9eSNFlGUVU88lbLXOk3KveawCxUAOHESvB+i4Y9odMyxNT0rMUzbYs1/h/9SHcUmthHHzgfwxs51bNV+7pHMty2T1L+C7UxVl+lUYn1wtLIWhKnuvMytnpjE6uGyaZ/Nuo+1/zDwWslGs8aT6jFs4yjmbejkZP0hKXD6wCqZKWO+Xrj8zQfRqLu+kcPN8EZjpt9WdMmkoA1Vdh4CqkDP9KE1Q/0a/fBof8fH/warsuoZOjR8bPUzWHWaspnlepaXxZhlMEbEWnz+v3C8SbqlBexlMQzFl+armOT3rvS3dL8WVtruuVtGvqr5p3zo+7DeDLcZJLKgEwRMXKJdH/LzTMIMiaIUTDA0hRlQoYPdXSBuZ2VVc1WR62d1MNdlS9mCa5DyIlwYtwgZpyQpraxSYfVmiMIPcdIThtlgdnZy8EFepbkzUaSpIoqNPRiBgQQP6jW8wVlyhp2+tfmdN2WGdLvKFsF/3ib8KooqlNQCYStx6CJLh0kWkEs6d7Q2oiLSR7kKqdAuj0VvLYsNrPums2yIKvoCyX9XJv068YtP+geOjV3e
 4sV1XMly
 r9ZPVvUMsRKe9vvfzM6VW+zKt8+DKzmImp21JeOcGKzOQ1agoiPXnYG2AY+RrrBqQ5x3gOHqkmfFzLMO6wXbcqs0FrjlddRpwHzG89Wgjck9QNvtRS6+zt2c26DB2RsDGFU2qxcgc6efR6fkyf3ixkFdRwf44Ya5/rL+KF20KCwEhluX5Z0yOaHO4P3+AClIVnxW4lkpWTiAtk2TFsXzkH4pbwY13nF96e21zNfOtnMJNyNmbwNYnjvCGNhdk0By0yfMivUDKxAdxleuSG2Cy7hAocytLbwPGxdKiMIvhZWBm97FZSz9X3PE6NSE2ezVzyChrlSbAGfzKwXI3/39HMJksDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 08-08-25 09:13:30, Zihuan Zhang wrote:
[...]
> However, in practice, we’ve observed cases where tasks appear stuck in
> uninterruptible sleep (D state) during the freeze phase  — and thus cannot
> respond to signals or enter the refrigerator. These tasks are technically
> TASK_FREEZABLE, but due to the nature of their sleep state, they don’t
> freeze promptly, and may require multiple retry rounds, or cause the entire
> suspend to fail.

Right, but that is an inherent problem of the freezer implemenatation.
It is not really clear to me how priorities or layers improve on that.
Could you please elaborate on that?
-- 
Michal Hocko
SUSE Labs

