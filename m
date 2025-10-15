Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EC7CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110E28E0007; Wed, 15 Oct 2025 04:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8D28E0002; Wed, 15 Oct 2025 04:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19AB8E0007; Wed, 15 Oct 2025 04:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBAF68E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:47:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B1A31A0425
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:47:32 +0000 (UTC)
X-FDA: 83999719944.26.E83F7B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 437AD1C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:47:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b5XRPtZn;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvDmNeoCngAvqfFphlxRaIVqa4lNYICD47e+Hsgb9Ec=;
	b=yf3kwFf9Rjqef8uSNBVz5eNlxTHnr+akVWqStl5b9lnuNnh9/2KIxl73QIKMGylOYQvp8w
	BHv67fx2lJaS+wVLjz9ntVFZyrJR5gTanQd2X9YJQSfyv/QQLIQswg7ay/6zgAuOerTQ4L
	QTw4fNSNREDDmXWQjLZceuRpOK3gSIE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b5XRPtZn;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518050; a=rsa-sha256;
	cv=none;
	b=m6Xq/Gp7dQNpTeN4G/aY2ZTRqQoUjob2JIIbGAdXf0gGpmtTVdExOsVA6vPOCzOjADThBA
	V7YmEvpT2mjEOGEw9SoevvUR0VbhgiQG0Mz0B0HJvZ2p5gNmVK+OvpBFy0DFIj+UF/8zik
	10/oOih3bsi7m1GWgsWUstBsW1cosKM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760518049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mvDmNeoCngAvqfFphlxRaIVqa4lNYICD47e+Hsgb9Ec=;
	b=b5XRPtZnrmk1FGE6MXuKbj6pNekxtFuxGl957BRrQZuCwAHUg15NgABduV3ccZUvXNFfNa
	RoBFyZyKjX+a9znLTzGNN23qh3eCqOSWNEVllJoxVnoCx2oHkORP/qetABPqzcOEbGcI+L
	lvNZF8pS9NQ7pUTcWlGlA5790kNgzcE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-pq9KnH76M7ypj_cv5YnO0A-1; Wed, 15 Oct 2025 04:47:26 -0400
X-MC-Unique: pq9KnH76M7ypj_cv5YnO0A-1
X-Mimecast-MFC-AGG-ID: pq9KnH76M7ypj_cv5YnO0A_1760518046
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8715f5037beso2614586485a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760518046; x=1761122846;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mvDmNeoCngAvqfFphlxRaIVqa4lNYICD47e+Hsgb9Ec=;
        b=XFeuY/MixyWggYRnZsN59rjdfQphurCQc6Po14yWoDoxyvtQwR7fEFHxJEQuQZDi4E
         5jM4ZIXqiBenke0WGv9U2VZeYTLvFKBYLkyLwxaN1voq7eSmI1z+sNp7ru8cqraJ9FBW
         VjugemGPUDpI+SvGjZR90HK4ZENHltGXxUWKJ9awZe3993VrzpRXWLOSihXLWOSk3Y8Z
         XDZLKNJ30r/12VGO628hfNW5m6dMU4NIkXQsMPPz+VOJlsxvnwA9i1DXbiMfxWSkfFDa
         PgZqwXa5/2l8LYhokCylvZv9Tn+iWO//QiYBIBlvxaN30fZuD/mytwCFSFNZLLyhlf28
         NNgA==
X-Forwarded-Encrypted: i=1; AJvYcCVV3ZgIkH9I2Os4KTmRERb5umfw4pdZ2AgT/TsFJaGrw4qfpofKYmXE1U7JxHr9xpzwZVqoZjiJ/A==@kvack.org
X-Gm-Message-State: AOJu0YzrIwSBTgbrOWax75/CUNNVy7y0OaFdv6AllQrF5wQUkYs3TrJ/
	+7JrP6tHTkMQZ2zTkBSIuLtZPVnLQF/KS9/s19eh0glBNrBUj+M1aQErvoSj5vOV4rT9iIBppBW
	+NMhb6RSIrNMt01OEf3OgJu1iZ0aJRy7OSfGDgVHfB0zY2RIapxbN
X-Gm-Gg: ASbGncsBui6nbHOuhnoBzBScIg1DlA9vBoQpc9TJVlBMdCBN/3py43++pmfxV2OzNr3
	bAdYwoEcK7s0zc72kDujDXCEC4tD3Fymbz7Xo3mz9KdHlPxJ0SAqe8n3oynege+d/MsOrNCd2Pa
	fx6bu3GpOxsxT4kuRxYM9uUuwNB6pWEOjAsZPlkHfZQebmDy88UjYvuJKqBKPzV3rYO4ZDwM4Ur
	UszKT3Y6XlUZZOAjyORtpaNQus2qPxG7Ibym2Srbh44raZWysiysWqfRLmIr1tCACconbcq5yh4
	azEzB452zICMo6kL3zllJHAANvaqxLaSlxAuXJtElr+NI6Q0Qp8jPjocg3M17Sc=
X-Received: by 2002:a05:620a:288f:b0:862:ab87:ce6e with SMTP id af79cd13be357-88353846127mr3526612785a.27.1760518045764;
        Wed, 15 Oct 2025 01:47:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyPR7ITdiSnustS+ancsME8Nm74/0O7iLaBKc+qKE60Y+nTtzXmrVeAynkx03IohwzGSYLUg==
X-Received: by 2002:a05:620a:288f:b0:862:ab87:ce6e with SMTP id af79cd13be357-88353846127mr3526611385a.27.1760518045338;
        Wed, 15 Oct 2025 01:47:25 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f9adb31sm1357375685a.19.2025.10.15.01.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 01:47:24 -0700 (PDT)
Message-ID: <9c323deb-ded8-480a-ab96-34ea47194a16@redhat.com>
Date: Wed, 15 Oct 2025 10:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: selftests/mm/rmap: verify correct RMAP handling of COW pages
 after fork()
To: Itamar Dalal <dalalitamar@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
References: <CAJoePDqCd6F0ai1itmVATawqMQzB+JRi4NUtMJtxyeOVOT56VQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJoePDqCd6F0ai1itmVATawqMQzB+JRi4NUtMJtxyeOVOT56VQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z4935Q2wW8fKRWL-18A5WWuRF95CF1rFkhZN4L6ctWU_1760518046
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 437AD1C000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jjwsn4ayt9umfdd8dejzaizx8u3y95fe
X-HE-Tag: 1760518050-322388
X-HE-Meta: U2FsdGVkX1/BsDNzXCDHTUL7FFUz9F7cGu78SVSa8w3f4CkUqUGoA8COY5jJ2rkKhDb0vcMWzljjt5ErV+kc6iMq1WC/9rCDv20yOOoXjHVpRDJAhkczAaB2yl/a8lbnpNyGkjM13/evZYVqd0x9PJ9EumQmf5GmRhxb7RcwTh/MXmSrGA9zcR5X8cCOFUyBAv6yXxFbpMmuDeJ+9H5gEYHhzJm12IlWGL5Vx+A06UdukhYpGPSPMszQcPb6+oUg7/bdZIjD+n4Qm0Rw8JMPz9zJcCql0L27w5qD6T23ru0sF/9/9TuGGg/um9aebXUZi5yRlE2gL1aoTjJPQoTkgLg71i7w4LrQ1IC1SRWmeT0/6TGJGTOxSWFpi34S9/5CQLNx7uhGLZiErj+7lukkHqZNjp5ITh6H0lI2lDZnDQ9DxqJhKxS1IV4nzg8L/8kPKxAo0NF3x40j0WFnYbM3pD82/6q4snejnvQEjYOxn/yn6De3R/ka9Aa3SitN10cMKilESQRM1ZFwzYGCxkYwKfOgqeGNiRoz1NcFuONTR7C2qq/hLMcbxs5R+/CJ16UvwsFxbRSE57HqY+ZsVzbze3Cu93UeUDVa6k8laGiJWfUncDA3s+KCsYOb2dVHlLg2E6OEHRHMGLGRrl1twuXUAaafAcEB8nOpjn9A5WPg+Eg1TaYLQiVrzuF0YsGWcZ90Q46yaBUOJfQqK6jMXyx/dkWSUdIaVr9N+o5owC1ltz9HehmcMRws81d91VvBnR9+tJE2nOKzUVAvtVq5x05RRqLqsrkHeoWroA9KvLkR3JR0CLOaj4tZjWvyhHIKbUoZNf+wL/2EAv0uf+I2nBAPRJicD4cPDkg+1wLEoaLwI8kYHq5mTgsBhmpYdrrYK9FC+svQzCAk/A6VGqUssRHIE3jw76biXSsXi8hgMx7IQuh8eK8QLoywspnm3fj2ma0mWTR9hDVWS34ROIJIjk+
 1NtWEYcb
 mQ5GI32DhcMeCxRjJqNx8sOiHI1gedIa8Al/AP4geu+tV1ZfNnRauICow//W99hUXSmiVqQf0ZeFE457+q0HjS24U4UhVROZS5fxIiZ/CadlWVnWWGROS7v5YfmDWyw1xrsftZv3yfQ5uTNk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:33, Itamar Dalal wrote:
> Add a new test `migrate.cow_after_fork` that verifies correct RMAP handling
> of Copy-On-Write (COW) pages after fork().
> 
> Before a write, the parent and child share the same PFN. After a write, the
> child’s PFN differs. This confirms that proper COW duplication occurred and
> that RMAP correctly tracks page ownership transitions during COW events.
> 
> Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com 
> <mailto:dalalitamar@gmail.com>>
> ---
>   tools/testing/selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++-
>   1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/ 
> selftests/mm/rmap.c
> index 13f7bccfd0a9..2ba3361fecf0 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,47 @@ TEST_F(migrate, ksm)
>          propagate_children(_metadata, data);
>   }
> 
> -TEST_HARNESS_MAIN
> +TEST_F(migrate, cow_after_fork)
> +{
> +       struct global_data *data = &self->data;
> +       int status;
> +       pid_t pid;
> +       unsigned long parent_pfn, child_pfn;
> +       int pagemap_fd;
> +       char *region;
> +
> +       /* Map private anonymous memory and fault it in */
> +       region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> +               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +       ASSERT_NE(region, MAP_FAILED);
> +       memset(region, 0xaa, data->mapsize);
> +
> +       pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +       ASSERT_NE(pagemap_fd, -1);
> +       parent_pfn = pagemap_get_pfn(pagemap_fd, region);
> +       close(pagemap_fd);
> +
> +       pid = fork();
> +       ASSERT_NE(pid, -1);
> +
> +       if (pid == 0) {
> +               /* Child: write to trigger COW */
> +               region[0] = 0xbb;
> +
> +               pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +               ASSERT_NE(pagemap_fd, -1);
> +               child_pfn = pagemap_get_pfn(pagemap_fd, region);
> +               close(pagemap_fd);
> +
> +               /* Expect PFN to differ after write (COW happened) */
> +               if (child_pfn == parent_pfn)
> +                       _exit(FAIL_ON_CHECK);
> +               _exit(0);
> +       }
> +
> +       waitpid(pid, &status, 0);
> +       ASSERT_EQ(WEXITSTATUS(status), 0);
> +       munmap(region, data->mapsize);
> +}

We have excessive cow tests in cow.c, that are independent of any PFN 
checks.

So I don't think we need this.

BTW, I never received a mail that shows up right-aligned in my mail client.

Seems to be because of

Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl"

The whole attachment should be dropped. Did you send this with 
git-send-email? :)

-- 
Cheers

David / dhildenb


