Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68886D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C770C6B00A1; Mon,  1 Dec 2025 15:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C274A6B00A3; Mon,  1 Dec 2025 15:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15BB6B00A4; Mon,  1 Dec 2025 15:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1EC86B00A1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:22:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62AD41403BB
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:22:12 +0000 (UTC)
X-FDA: 84172024104.25.34BA157
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 71B0FC0019
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:22:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764620530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJpgaUAKXQbdrLIth24lgYsco6HuFX50DZQaJZx684s=;
	b=3ApjtLHLDjwQNMhDn92p+2I2WKvTAdMV1K+3IDUBWyY+SaWFpUWsiOIQBNwxavPwjQB2n1
	XTSU6uFsyPet+NCuz32FIfKes13EDTjO/k6FjLwAU2QrDcrreaG3UfDwZ9RRYaRHxMza++
	DFuBORsnHmycI56s0f0vvmtfMOUfhLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764620530; a=rsa-sha256;
	cv=none;
	b=V1HGx+XE1iwOcHJzAyJL6/XZbrZ73YfbEaKIkoUN2TKQllNh8D9YvF0JhrVXMZO0TU0X/d
	WnknysrO8gZr/2AcUTolBUd7KKf5wOpfhzk8n6hiya0OXRfjxJVOhowRbq6/ZgOgG9aPHa
	M7P+Yg62FebLVyFWPLuFyuuYOOW1w8A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b1b8264c86so433630985a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 12:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764620529; x=1765225329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kJpgaUAKXQbdrLIth24lgYsco6HuFX50DZQaJZx684s=;
        b=o2u66JkLviMeBxBCPh4SvWUGviyNoDh6Ne9BGmRC9Dy1AckRMVMcKh36K0TTE9Wlpc
         3iuc+k3bJ0lGyd6R3XHbHfYghUHqq5q+2NVFs1vPuo0fTwVsY87q/ICYfj5BG8R6tmO3
         Xfa0rLb3yDX7ELXEHW9jJ69Ms1VVivHCB700Qr2BhwNcVL8ZSmsNKTyz3DgcC+CRRLqA
         P8t1hlGv9RyY8gvNbO7nmNYZRIllmdSyJ/Ys12kdlkgmf/JzIVLKJax1Qz5ld9lzJ/XE
         gNa0mkg1aPaflLDw8rWtiar85pCa7WEYKg4iticZKeFOBK3FybPbe4ZYa1kPQlfgDAFX
         +zNg==
X-Forwarded-Encrypted: i=1; AJvYcCUFtFUa/TosDGOBlsbUh7F3o6jsrl3FCpvF2yGGex9yYUCCPkAoeeGAyT85m8UO7jKLV0RIm19Eaw==@kvack.org
X-Gm-Message-State: AOJu0YzgQ51R/19Pg1F/asAFtO/FhmuKWLxNbCune8W0sBRP1MjFfY9d
	kdE+Wz6mJWd7FWgaOYfUHl6VqxSqGB8njfbkI2AH0cORMef81fB3awzQKWAFsFBhbb7ODbKPDSj
	YSnfJpx/LuBE4tlQysO7EOajFYGkJ0kc=
X-Gm-Gg: ASbGncs0jfdDCYeWUMiCkoW4UJ2a8TSATwRZGDt+wjiz2dkc5aixrfDT0uorVJ57Y8n
	5+FDEYYCJphJFeKhRSuNIEkdNdq/T7wTU5EZDWK8BZ+cQOa/cRPkyNK6IHPwHGjnxzYEXuy7M7f
	bGuqCwxr4cZDITvj+uoAKgV7QdVqAICIW5y+Dnyovl9BEaYP8AANi3Zb4Aoo1P8O3FA/9v9gju+
	8uEhGWFOZqBaUpAtI3VdS7yMkyX9nWCknYQiWR1TIxJ3iaQ7wXF1a8i8cMgDMQ50S3I2TkJLRPA
	ip8Y
X-Google-Smtp-Source: AGHT+IGm9AutZ21qFwjaDLumrmoH0pEpI9Lp9JvfH8goxtm253odaXyBjQEMtnVmRsp2anjQVOs0G2L6pCMk8QyknuA=
X-Received: by 2002:a05:620a:7106:b0:8b2:e5da:d316 with SMTP id
 af79cd13be357-8b33d48b7d4mr5190214485a.87.1764620529165; Mon, 01 Dec 2025
 12:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com> <20251201164338.GA430226@cmpxchg.org>
In-Reply-To: <20251201164338.GA430226@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 2 Dec 2025 04:21:56 +0800
X-Gm-Features: AWmQ_bmDfHWyQfsGvK_qFrw5gpxxJKnNf3RxMfaofT4QIFsdlQ7oQ0iWuca2RK4
Message-ID: <CAGsJ_4ypBBqSjcHOx5RYp3iXCZ65ZXkTN90Qoktk1VnRCGdszw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71B0FC0019
X-Stat-Signature: od7549bu6ccir5kfzokomryac5z5mmu6
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspam: Yes
X-HE-Tag: 1764620530-7385
X-HE-Meta: U2FsdGVkX18SHv3Zq7rJO9k7hrOqNF7SwZ3+L6DbfOScoa90Mv90PGHGOJ5v3EQGJD9A+Wgim9joHMeldH6ttDS87IxK0+X+chdyrDuZ+FMtj7W2A0zdgPm1sXlyb6lAhYcqnJaj9ijEaN1aSvZ4VxHgRMhQkV49Ho8Wq/Ej3xElhG/KQdrZsd61ET5OeS1iRHxDDJnLS+UajisMJPBkLM8DjT0vkLuHYfh7JzVtxG4/P894nX+wGdjx+TZR3kh+dFg7aLNVm9pZKJUqs+RDDeENC+/BMgJkfa2X65Z7/wEUaLxxAdNlBZm41DWZLmqcMVA0zPy2vmubYxi4WypVtvvG8SdmLhF4PyQ/HD0TnwS3ugOKLiLJN+MI1tWCSqdwsz9gXhrweE5Qtlhk7U5czphlki2Vo8Y5c1i+NUyqtCDkdhsRwc4isWkvEeXfyyeatJylzlHvdKkia0a+U+SZSBUbnx9qlnApYyx5YUj5cza9JanrtD0ybP8osMKEv03f5u+wKK1CQH5db1L++9v3RUICO/VN3S9aBqrjWMoDp8vaWaakcpdmtrix55pzabwm17LS2G/DfSe7ksyqt37po94eLDgU7DNwhnayRgG84iQKQMvNhVV1AaHCEQoOzznLs2sNXNWzU0gvKWtSJuwd8h/1G86zAtxFB9DP8jqNz/Qe6dR3wPxMra82aEEcLw6sedpHMRBfZMfkiACPj/JdFtvXqczOjntmm4gohA3p0n6qk94tfkFqpUxs9NVSNTkD++wsI/NOZUaAaqq8Nza/4ReGrx19okNwPrMK9mXUMDtlDo8zuES2p46GdQmUyA6qaHciykU2T2RzCf+tR2KQo5537bvO0vcd0eIt9IU7lMMy+NeR1IiG6yBb7MMmFkfmZmTmrvB/qABIfS/HBAEH+wOkyX6NBQh2VWNHIF4YN6T6PH4LAcGdRrXkEKiEnry+KrU9O9K4QYKayLFTRC+
 0f0VdgQm
 /tK0XxrcZFzA/JuU2fORPuScTc14hANVpf0edVvR1r3WRa6GCmmyNlmfMqvOpGpugnsdd/6QdDv8aklyx4SEUOSLRK+BhlRSwzq5jps/qs6iXl7OJhq8SfI0PCxuBRUwwjH+eCunzJ7naUe+Qh5avbo3dCpabiXb6tP9ezwC8szPC7jy6AFFDQhCB9f0us2lc5JMUoKDEqMZoZgdUXj25F+6PlNhdWZ4IAh37WauukULSlgFPeMf8jvWVMEK83wRvIR8FUkpMSOmGapAGfiJ+5NlpRPI41hFcnbaGijBPB6m4M1yq6b1tyiRDNIMsO3kQxWiIPCJEHK9RuqsNrGX/0CLDGFBX8eRrRAwl3fVQgto/VJxJuO0i/dIUWo95Hy5d97ILYbkyuJfQkBB8FWBhGchB85GUfa/aBM555ba5KnynhjPdAdSUnKQsRlSMSWXhOKbp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 12:43=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
[...]
>
> For the benefit of anybody following this from the sidelines, the
> third zswap maintainer also expressed concerns about Chris's proposal
> upthread. He works for the same company as Chris.
>
> The reality is that Chris is failing to convince others of his design
> direction, and is now obviously resorting to manipulation and hominem
> attacks.
>
> During the course of this thread, Chris has asked for "a little faith"
> that his idea will work for all stated requirements, without deeming
> it necessary to explain how.
>
> When probed on technical details, he stated that he doesn't like to
> plan that far ahead, and prefers having somebody else iron out the
> implementation details. He also referred to high-level slides from his
> LSFMM '24 session - which was received thusly[1]:
>
>   Matthew Wilcox agreed, warning Li that he was setting himself up for "a=
 world of pain".
>
>   Jan Kara said that existing filesystem designs are not suited to this t=
ask
>
>   Hildenbrand said that this plan was introducing too much complexity
>
> His first response to criticism was to invoke his <4 week status of
> swap maintainer.
>
> Meanwhile, the design direction that Chris is construing as a single
> company conspiracy is anything but. The collaborative origins of these
> patches are well documented. Chris was CC'd on those RFCs. He notably
> did not engage in them. He is now lying about the narrative and
> choosing to attack these patches in bad faith and out of context.
>
> This pattern of behavior gives me low confidence that Chris is able to
> collaborate and compromise on a design that works for all users.
>
> And while Chris has been quite vocal and opinionated in mailing list
> discussions, his actual code contributions to the kernel do not
> instill confidence that he can solve this problem by himself, either.

Hi Johannes, Nhat, and Chris,

Thanks for your valuable input and discussion on swap virtualization
and swap.tier.

I=E2=80=99m not an authority on zswap or swap, but I strongly encourage eve=
ryone to
stay calm and focus on technical issues. Together, we can make swap work be=
tter.

Perhaps we should allow Nhat and Chris additional time to clarify the
technical details and address more of the code?

Personally, I have had a positive collaboration with Chris on resolving the
mTHP swap allocation contiguous issue, and I have also seen the swap table
emerge as a solid design. I therefore expect more great contributions from
Chris.  Meanwhile, I share a common experience with Nhat in addressing abus=
ive
language together in a specific thread, and I continue to see Nhat doing
excellent work. For these reasons, I hold deep shared respect and appreciat=
ion
for Nhat, and I am 100% looking forward to collaborating more with him.

Looking forward to seeing more code and technical details from both
Nhat and Chris.

>
> [1] https://lwn.net/Articles/974587/

Thanks
Barry

