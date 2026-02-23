Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8724EC1118
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D466B0005; Mon, 23 Feb 2026 13:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAE76B0089; Mon, 23 Feb 2026 13:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C8E6B008A; Mon, 23 Feb 2026 13:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C40BC6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:29:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A8891B5818
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:29:14 +0000 (UTC)
X-FDA: 84476558628.10.799DD8F
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62FC540007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:29:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQXTJ9YC;
	spf=pass (imf11.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771871352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Whh66IdtUGy70gmAC1xBj/5A+oOvnKahSu95aS7N60=;
	b=A0EVqBTDOKP3TOn7SDa7ezNedEMCD0CXh21dFRgaB/IyetCfQXKYlEEh65WNUBuaQAk9w2
	PRTrhojY4RvMH+OIo+wsyw9GPugpw471SZJMofcqWUfEd1cxAHnAw0Hkslpe7VnzkO/2dv
	W6nKONgj4Gjj50aQ5CcQVJ5/4burmpc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQXTJ9YC;
	spf=pass (imf11.hostedemail.com: domain of avagin@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771871352; a=rsa-sha256;
	cv=pass;
	b=vMgM27E/BwE0O7S3eyjwGqrmvEvXNyz9WfrvvWAxMcfXLnxlybrmQ3m4h7m8D/FlMGboMM
	LO6UzaUkit7MD9Qx6zTHTOXsWsBbiuo1nMHWW7prcf+zmZZ479w/lIhxPszb0qHvX+hacI
	g3uBfV6BhhAg9XC9893z3wxYgTEAQBA=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-408778a8ec4so3972576fac.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771871351; cv=none;
        d=google.com; s=arc-20240605;
        b=FaE4TQn4g6p+QfA6ow2jMo3SwFFgcOTK+qVGoIZumsM0urjWg4DrKStuNmWS3A1cJ5
         OFLCINy5tm9egNDOeiTVE+VMnfO8QZ2algcD+5keKq+tH6jBA84DRJMzC6GPfIVn09s6
         6xkvMf61OZMpm3nmgbBfv+8FgsDJQFAO1ZTCs5CYYFqd8/44Ag2I8roisdQ3b3abc9G8
         Ken9SXX202sNiqNQpAhuOMyTI9pPvmh1+6ve19cYqW8k6I+ZPwKoO9yoTeZ9iH1HzXzS
         fJnaa5UxI3+h/myElEn+YW8XEX1/CWeFUXXpHxzZ2fSgkzwWXKVAF3HV6DrwH4RHBuVO
         OAMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Whh66IdtUGy70gmAC1xBj/5A+oOvnKahSu95aS7N60=;
        fh=bEe1jvaDovbv4pP2WuHP4Nb9802FV8SnMwN/9SxsGSg=;
        b=PycIuKzSmF6njfUYsVb7crrpjGSkCq+Sn+facHn+jHAbBg32/P0elS3j5Y++WkKjTz
         tZ1oMp2KNPJvxWylzT/Wht7FbBi837u877H0kI1kNu/lGdxVxC+HOrQmsNNVsFd/8XCU
         JrUZWiy4xodu7fJWBQIoK8aC7GZJVs4wvxwxiC40aT7gSPWX8Mg+SMsnRCjux9RRfvO/
         nxyy1V++vtMxL2Hs8F2vKEOXQ96lMDKGONzzd4Jv8JEuo3N2+GvEl84ps6HRJFv2rFf0
         kvqE1CMO2ezuHTh8ivfhBnQYTpLiqjGR1NYoHP/uOcVpehT9qfAXmGDpx3KRHF1gz1BG
         nfWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771871351; x=1772476151; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Whh66IdtUGy70gmAC1xBj/5A+oOvnKahSu95aS7N60=;
        b=hQXTJ9YCRXTaJ3WbFJGslAyefSBHzpLDZw8OUW2H/R8tvvqagcWbJ0mHF+iCC4mbO8
         KFxDw9hgbZ2eJYs9+OOaR2UqFf6lmwsgwL5jgujlHwnmiEDWurEZ8P7nuX/No8qB88+B
         qk/XFkC5pkgNdlNOXB+eb6SB4Kd+KQWYZhYXosPmDFlA9mi/3NgQqR1lwTqMMLsDJT83
         pzguZ125masHmFHVmBz+S6rUUrNp+NP8aywfKnRVTCQlfEZxVsu3+Vx+oaxO34D+yijl
         cETgYmTE5uT8fPZowAG1ibRq+mmSqUuJ79J0aRVl1Vkr4zDmIgPqY0dGCnSak4TzdQCA
         Wtcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771871351; x=1772476151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Whh66IdtUGy70gmAC1xBj/5A+oOvnKahSu95aS7N60=;
        b=gGnqNfBOOixYnzNdiSq3Z4i8HhBwUcJplJml+iiwmUOyPPKHF/vdnrRt9ORKzhIRLe
         OWWV2R8EfprcOo/Qu0qMQu5sJjcv/8pp5Ond2ZBEZ7QmvwSqIqW3W80vvaoejoJmRvjx
         A4ncCkSPuV9Uuj9jV6csagu/YlfHVyy6OSt5LoSycDZphYHkdkEro5kSkGo7pnSDXUqp
         mir5t/ht8FwDLS/sI55/youI3yW8NEAVQn1QAIjDN1hE5AbmIhegRjo85UbMp+f11HUN
         F2sUsIa8r9sD2PQ8LwWhUAW0IT6Ax10xPPX3MhPDIlkDHNG/eR5OIp1l6eyJSefxxe5j
         qLxw==
X-Forwarded-Encrypted: i=1; AJvYcCVtkIAXxdG0AXFW6xyni9jP6UA7jVYMbb63VhLBzIYnWVBT2IRG1PnFMO1TLWm+jGtH+9HOvALvIQ==@kvack.org
X-Gm-Message-State: AOJu0YxZQzcXVDzHEnGpzEorceSbNAEa3+o1XWXQkGKVu8/zdXH+1SZX
	IUBJJCjsRKLP0zMkmck3gYGsGYIf5NTirja4jpF4esaSQW4RUiIua5w5dWgcHbdz6XEcnyAvVG8
	HWhTg+F0Bo9dSWm6EcQ94HCwTfv+6DX8=
X-Gm-Gg: ATEYQzzKToV4DnLIwZzhp1c6ackXqD8TLvNsM5SkhMWTYzx3D4EgfiKWvPyg2rPp3Ok
	mewDATJvbYp4tjEBA7Iqf8Mhz8E9qu/hB5OEi+UMYTAHFWbQUaMo9InOgwkV0a7/eaOlBi6x8pJ
	VPUVI84b9X9UfWGfbn4XamcvoeNeIxQQjviwm549IFJiE0Mkug94RhOiEPCsHAUScoGfsjG8hwi
	rOSdj7Qi+bLDqNvJYCNgEYtlJnASmqCsm2kvclJrw16dv+uE2xW3rJ1bcMWtDkaBs1q2l8YL/AM
	7jxLyew=
X-Received: by 2002:a05:6870:a79f:b0:409:728e:3f2b with SMTP id
 586e51a60fabf-4157ac28b31mr4638255fac.1.1771871351139; Mon, 23 Feb 2026
 10:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com>
In-Reply-To: <20260217180108.1420024-1-avagin@google.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Mon, 23 Feb 2026 10:29:00 -0800
X-Gm-Features: AaiRm516DL4wdtFRf7EQJjraaJNo9amL-ln10-8gw16pLLQ7cUL2md0iZsvWpvk
Message-ID: <CANaxB-wNJWhyM7JUKT3y0Wp73=+8XZRnSkdudxqDwEo2FaJpwQ@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] exec: inherit HWCAPs from the parent process
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62FC540007
X-Stat-Signature: ba6f187t5xrcnwde5if1xojh9cz1rn8j
X-HE-Tag: 1771871352-520738
X-HE-Meta: U2FsdGVkX189dNOQ14ceTvZ+kU0LoFWavVXlL4zcgNd+nGYxfKFLJ7OCVsBQHIMnnliemyHxTo8IIFsVWNrxg4kiCcWt9a84+oPHj9mH3p8Qv3xBbRAz9znZ8xvhtGT5RBejUWC2Pc/UGsukBkWbhrc465dFLktY8QkdghoWNElLM+FHggypk8IIXnIw+h/3+rcfdtyH+gTE2twpQiDGsSqc9cU2dpEo0TYJmclTMfokojU6+l6MBh75xfb0Yo71lmvaAYiGy1ch+sAPK3ZQDbgyYVseSfNuq7j4HYf2wlHIENcNToLa/J2TilTulcRqYt2IXFbBKHvsmfsQFvDbuXnv2u7KMrhdxAAw0T317jE3TQXYi9P/o+wdU98dD7ylrGwlBhgf3F8idmDc6f2cPRrjoD1HbMpQhsiDQ+jqhWurfGtdS5eknkVYOhpY1Ug3KtLrTE4flMo4NYUR8sKuTrpfbRqD3TSnsOykCCLjyatQU8AMZfd6TxWmRhA+wqQlhRxuJmsRUJdzBuFWFoFPelnLhVg5vgBI/vT29oVeeGHbkYGFx/ToU7fO42BkapNeGU8zCE8iYscBpOC6ZCAIqXGEIRKuGxNyfG2I/KNRyo39gcAQB6wYFtKNANQZnJ6xQHyZdgjZGtA4F5eOeyYsg7ZNA7/vrWG8T7IZNOiC8NIxO0KinOltN2auPLJPRPEWi0VGW4daa/q6MLiGasVKcMosX18R8ZN6yDB8jN8RwT5XeeRPE8s783Z1J9W01wMbc/0zRSvADzVkKwnz7s1Nixd1saX8RJhJCKrSTN+hyX4g609gqwADvJRpAUn6Q/sl8G0fZOGFT+bIzaW65RpHmWEmSlPOMUwn6XIoooe7Vb/LaaHI/aNp57UEv8AJWI8Vz6yfjaWuSXsO9PFr/ztUDRhfIeS/s9A9eTRMc5HNMYRniuXpWtjc/zoOXiHmTuKS2tWvlEDLf3uKonnTChH
 H8zOchvI
 uDzT8pTBAIvjmWJ/lF9wlTAu4pTOYS2cj5p3vdl7Rmvtv7zTFPgsZH7S9zx6pJT0C3jL3AxJWCKQYo2OouY4DsnULx72CVTFAc7W/Cj2N4PnQnyjQEohyWBsVWsxnaArtDDn671E2hq3/H9NlVhm3QN38wiQLKl0Moou5mbxgBMD70ITIEt7hkSJekHfvW2dnOHXp1lixms/iLDaYKRn5NC49z7NQNf17k9ialXLY5vCOjShMkOzIMNu9Mk6AtX6Sq1Quncgf0rpWxmpPj4JpCrXmqD63kUjbct/DHc3zkGXVl4xCbboyHFGV73KngZHpiEE3WpItFOilexQPIALOq3dVu1Li3xINp2hjw/D6rxlxXL/V7JGhzJ54iVe8QqKATJSwui0wv01pxAuUgMqmKzTnx0rB761JmfGu5S8M/vhjv7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:01=E2=80=AFAM Andrei Vagin <avagin@google.com> w=
rote:
>
> This patch series introduces a mechanism to inherit hardware capabilities
> (AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
> modified via prctl.
>
> To support C/R operations (snapshots, live migration) in heterogeneous
> clusters, we must ensure that processes utilize CPU features available
> on all potential target nodes. To solve this, we need to advertise a
> common feature set across the cluster.
>
> Initially, a cgroup-based approach was considered, but it was decided
> that inheriting HWCAPs from a parent process that has set its own
> auxiliary vector via prctl is a simpler and more flexible solution.
>
> This implementation adds a new mm flag MMF_USER_HWCAP, which is set when =
the
> auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve() is
> called, if the current process has MMF_USER_HWCAP set, the HWCAP values a=
re
> extracted from the current auxiliary vector and inherited by the new proc=
ess.
>
> The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
> in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.
>
> The second patch implements the core inheritance logic in execve().
>
> The third patch adds a selftest to verify that HWCAPs are correctly
> inherited across execve().
>
> v4: minor fixes based on feedback from the previous version.

Kees,

I think it is ready to be merged. Let me know if you have any other
comments/concerns/questions.

Thanks,
Andrei

