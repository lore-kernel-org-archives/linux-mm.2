Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D95ECD6D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E696B0088; Wed, 11 Feb 2026 14:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7763A6B0089; Wed, 11 Feb 2026 14:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6236B6B008A; Wed, 11 Feb 2026 14:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5C26B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:40:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8BBC13B38F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:40:41 +0000 (UTC)
X-FDA: 84433193082.13.9181FBC
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB9DDA000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:40:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RkgrGeGz;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770838840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtFHLX3t7mFwB3FyF/7aRQrPd6PJdO/LGE1y0kBPp6M=;
	b=dl5QyTNmol2hPF/nze+a6xL4tw570IntWP471tHc4+7y7Wlhkl1Leko/VyskYTDQMW4Ieo
	bD48Xy+vN+KPq9nE+lSXb2Er/DRdXTBhWUhiPbnOLOhKVvjD0oUR+fm01/CncbCmfn4Idc
	xIyS0/HVgY/RXqVZXw9vd1AjSxJz7lc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RkgrGeGz;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770838840; a=rsa-sha256;
	cv=pass;
	b=yjvC9JgA/TM5qsDoOL+Uh5ww5Vg7ipP0CNIE1ZdN9Jflz3sIDLVE7zq9L1MRLvpb95W8QO
	aOSuAQOHbrhrWXcKA5LRdGIU/r2b95HiSyVB+jAoFxATJPdEp96AnWc7LUoWEALv8CFG45
	4zAiUWhIkdab7EJVsU6Usja2qli5ZLE=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b883c8dfb00so431046466b.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:40:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770838838; cv=none;
        d=google.com; s=arc-20240605;
        b=hA7ZxxECNT5npmcPwKqW5o1735IiflEp//q1K1GdYSXgNfaoy7Bv2HQMEkkKmklrDk
         +c4DEl66GuATnfD4d/24n+ac6U+HpzdJ2GOJLFSNvOFN7Iz/9KMboxJs3ypG3ljZGcci
         S5b9ZYQkAUILprwsygifiqbdJL4yFcR7dceE4u7nzunpM2rtFutr3rQrL7QYLviv4mtO
         2lvl3bawwGi3TRLLXFJqjIPkTurczA1D6ols7t2imDQd6sUeo99cAGKvkSZ+cjv94RQ3
         veBSfNNIQ4GuWrOL68dFRQHU+xS1OvjfDRnGqmoqKVSb56CTXdA6wREjLuA/BvEa4FQv
         cVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mtFHLX3t7mFwB3FyF/7aRQrPd6PJdO/LGE1y0kBPp6M=;
        fh=SMspvBLxP7GAK97vYVgsYOlJqJwngNjezoVcbpdhC0A=;
        b=T59lV5kjmg2xvdZP85LlHAnTSPXpQ4YpHmW5UAomJGhIkYUVNJQNBqzSrVvA7wRL9a
         ldshEFHTNZhZOJk/r/LBPYV8j8ApRNDenQhoIZ0PbaPBIYqUamnvotJVWIRj3wwl3oP7
         tdaJPSqlkwlPeOJgK2GYyCDq4v3p4kU0AkKoCZ8ISC9nkAyWXE8WonJ13ZHHzPPvt6Gi
         U8Y9UoYSLQ/qQES8FGA/NqmPmWAyhmxbbA2vA8ApVinu1FSK8bEWQStB/NCF8OKEvAhI
         Emwji4ptlvI71xo4MREzVhmoQ602uLtfNhmMJwti1ptPxjMoABDM0QJKB8jIJyOGhRYl
         kM8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770838838; x=1771443638; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtFHLX3t7mFwB3FyF/7aRQrPd6PJdO/LGE1y0kBPp6M=;
        b=RkgrGeGz/j6qIGsD9zMPjbZZC+V5VxwFyTXDJ4F/DqxaSXYvBrxChcc1oniVyEzAjX
         L90hGZm1zHq1stUfhrewmXPZqExr2FZRZskVtkkmm3RdMpetGGHyLwnL90ChGMfyIXA7
         hZ4EKqg3Rf+WM/H9EuT1z3j7dlRDgB2cWrcGHjreaUyFoivCBOMTbYVrKw77N0cQDy5p
         AsujuKXvmwkDaXcfEQWTL9WjqlSzAL4ekIXaPJEB9FgpRu5cA9sOzJzhB665ooL2ZZ1p
         Fc/YHstv+PRJRxcY9aOwAFSarhjR8CuMjbL5k2bhiXrT9b8WZO/A1a3xOh+CFaglY1Tq
         NbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838838; x=1771443638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mtFHLX3t7mFwB3FyF/7aRQrPd6PJdO/LGE1y0kBPp6M=;
        b=W63XawiS+AMJInon3YQRCJzaIOZZQwYO5cJtyxIjVaEwMSJBvyU4sJmfTTOj5S/bO0
         NajkkNpRbX8tcdXVFcLQ9RRwjsYsPbBbeg+p8ieEyqESASiXmvdo4/RjkiP8vYNT1NMM
         m8BF/m2RIgYOqA5Lef57OuUpjIbWCWv6GBjIrdJlh6NWAjHARmk3RVlAcG5fPMBXKmmh
         rNH63AvoWaVSIBYRgF4HRWL8MB0cuh2lWovo9eQCrasv79/Oiv0tSJNTWG430QtwuQVR
         lWnNjgr5CG7l2ytoeY4qQq55G62Jx7tUsufQV7d2T02/mCweUB/oWtgVTzStc90Qb1kb
         7I0w==
X-Forwarded-Encrypted: i=1; AJvYcCWp9o9ahLcROrV3S8wIL1qi8OPGfy21/UalYwWte2HpVjyIkCSFr3QOjKnlf0RNpuJ5T5h7KJh4sw==@kvack.org
X-Gm-Message-State: AOJu0Ywe+rF70mPNNhoeqKmVBokChkDWuuFuzFlZbOHSU5Hc78fEi/SC
	pAqCgevQKV1C/QJTBGkTiZ9a+cb7KAkKvI6eGxR0SqGO+Kg2RClJDbmT2NmL3CBerrRB4Okgxxl
	nUL/EZi8n6IPtJlUHkzq2EmjogkZsiicUm++dBR5pjQ==
X-Gm-Gg: AZuq6aK3LaBJbJ52kzYVuVJDfTAX0MJ0N/9+LTwhzF9+VRubFBC1QdkU1ASxVDz2ZQD
	htVQcdp2Z2gWIwrQgL8cS1kEhjKMM3PXLehP6adTGcMLp+5upV0L1aLvWf5p3bLXmdBU9VoG4+F
	Y7eXd6TJ34/4mqqs1ozLZ+ZDWGMt19utJ47OpGfLJRwaAd77IOHZ0vwX0dkyg0fa6vV0s8lGb4c
	ybIxWuPMZ9Y8oqNrbQ8m8UZaWOok73Ib7ltzM35jBGZjsN9rZQSUlKS81s9EWb6btt2QGkCHJAe
	qAasi4spuSgn589g2t2eo2DlMEo5UZ/hR6TjAg==
X-Received: by 2002:a17:907:3f9b:b0:b87:7485:b4a8 with SMTP id
 a640c23a62f3a-b8f8ea91a6bmr15769166b.0.1770838837841; Wed, 11 Feb 2026
 11:40:37 -0800 (PST)
MIME-Version: 1.0
References: <20260211173954.2091119-1-mclapinski@google.com>
In-Reply-To: <20260211173954.2091119-1-mclapinski@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 11 Feb 2026 14:40:01 -0500
X-Gm-Features: AZwV_Qhj_LXM_nkisF1dHW372t93JNjWhBHaT4GRxWYkxOjMAeZJR4yIQonUYk4
Message-ID: <CA+CK2bBfJDD5SPJqwCaGbaGZe9FncONMsck0QkOb8WwmDSh_Yg@mail.gmail.com>
Subject: Re: [PATCH v3] kho: add support for deferred struct page init
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: ao7mkgs3w7jsmanz8es6f34gma54ww6o
X-Rspam-User: 
X-Rspamd-Queue-Id: CB9DDA000A
X-HE-Tag: 1770838839-412002
X-HE-Meta: U2FsdGVkX1+ZQyVe2wnsmiCOe+5dnYMtxaIpFJHNmP9a78ZmlYbQilhjddpCUW1X30bqDk/6dfL960hNzWnZ/TTYiXc5Qme25xj5Jw03t1A8CB+lTnp8Pz5He/k9P91zgLzzX/Q+kS+9HdiEdXvuZu4Yr75WuM5sMfmUBVkZd8c6853gJcpiHVFOO6F2zSxuvcsOArg2HYHR2AjtRWHUIgdhUEPhcurC/DYpXruhIvCxhn30nMg8oMLNIEXh2LnvbbqWcb780OaunGeTJQdG//pHHo2Tk5pp45tJUkdIFX445qGCV/MkUZF5KWMPPdPG9RugFNsFtisl9lbr3eFE01HAd1DqU0964oCY8U+wTuzM3or3ZZfP+B21Lxb090pQ6MvRAkDuZEkdgWtEvPnS9FyspgBfLRc1P7b++DbnJmtqqgkOMoCVc5qWKeKNvXVLoWX85dBOKwpu42ZDfZQBhoPXoNKM7C6WdaumQse7p1FfnjNs315MLuKfCTO6eDK6XwLO8ePP8drW9kK4l8j9ETQHRQmtinwvfGiiTFoIPG+3B2Ij1EPxxX0OEYyvtWi8SeTx1Zj3Wqrw+1Nyy9e1wMcc81/vgZt3RvN3XpPBLYMgW0ryzi6nyaiuH/IMEEBIbS+d8Pe5biUrzrRSbZY76nL1uTVPtlvnv8jOMyancLcRYv8VWLUDTO9sWnbWgT3wiP5IMd2mQrd46gvghxKeliQhKNvOYEji6qpmL6i7Apn8a12i6aVl8GuR7oM0blsiDRF4bEPWSxVdt/UIkbQhDcKjQfITYERBiIrOY25ze9siyzUCn+OhADKiu+UhHxdpmHwvOyZP2UvcB+Sxc2/5QAch++cQNDcvWciHy2zBOm0MijR+uHYkWCD9C+2r2FElHMT/2GNQ84fashRjcRPPHG3Icr0Fli/x82u6qZKKkvbMPt1XWiMrWDfC2678uIA+ph+UtMt0zZ8XqXF4sK/
 u8bpQZLB
 ZMyo3r+hmVsTnwV5x4v55hFI5OipuKQKgieTPTPTNLshuMZQRTAXchJOnP384oZzJcnjh87cLaT+71kRRYhQfgTYLjrI6RV+Pg94GMuxgrMtTHZFJMnpYkgY0RPByrD7Hxh8i0kOlIwAJmn+zSDbsUludTlvkoRVqa9lsq1gttp3mC2t2zCBpfG+AlDCL1CD/Ns60smtPD6Z4dLGr//zbs2MjJPz0SlNi4l8jZSMqADsDwRMEZi4pLZGEqjcBhtfl3OJFe/yQmnxqbQMsH87xhqP7BHzJIIx5hFUSJsisk570bbxZ7vh3vy9+Ghjy0HtEFwSawsDLwJUbtjfX4uCnBS1kkny+egcNkMtEONyM8KxF9lM8VRavTKx++lwGzjWYANcTUYpJYSXWqN7IUwK11zmwK7wdjc/B2OUY2VAabOHfmYw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 12:40=E2=80=AFPM Michal Clapinski <mclapinski@googl=
e.com> wrote:
>
> From: Evangelos Petrongonas <epetron@amazon.de>
>
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later
> in the boot process.
>
> During KHO restoration, deserialize_bitmap() writes metadata for
> each preserved memory region. However, if the struct page has not been
> initialized, this write targets uninitialized memory, potentially
> leading to errors like:
> BUG: unable to handle page fault for address: ...
>
> Fix this by introducing kho_get_preserved_page(),  which ensures
> all struct pages in a preserved region are initialized by calling
> init_deferred_page() which is a no-op when deferred init is disabled
> or when the struct page is already initialized.
>

Co-developed-by: Michal Clapinski <mclapinski@google.com>

> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> v3:
> - changed commit msg
> - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dn

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

