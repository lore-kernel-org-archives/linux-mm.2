Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889E7606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HuPyUqUk
Received: by kanga.kvack.org (Postfix)
	id 6B0516B05B3; Sat, 21 Nov 2026 14:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6618B6B05B4; Sat, 21 Nov 2026 14:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529126B05B5; Sat, 21 Nov 2026 14:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11E386B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:54:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E5B5A059C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:54:10 +0000 (UTC)
X-FDA: 85460177460.11.99C9D13
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71F49C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HuPyUqUk;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795290848;
	b=vi4l/yNn6ujR9XskWC5hGVPHYZP2PQPCJ+/xjrR6SqhIHAVdGYgj9DBKsoWymUlgNyNsJ1
	BIlQYkrtLBeI1SIRxoMWAoGxIB90QGYtufW7eogiEp/8Y/A720YwveHbOYm4IX0PtgNg3I
	DmFk5MFabopPl5mYgDj2E98vl2MGxRw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1sN2fGHBg+DK42ooMw+OHw6UPh+x8wf0X6rkFNTrGI=;
	b=A5L0laKAXq1D2fqtWXTKwmlyJWjXhWk64taTRTTHGBLFRrjP7A/cT2bun7NDpmvtzd1k65
	3YdXJkIo+1uHNXUsvUugo0zaemgOpnKuqbJH2f/hgUP8BbebCGdPWzEwidIEAO7XLM4Qxu
	a1aKoExzLP6wiillAikrgEwgNcXU85c=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HuPyUqUk;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-85ac281604dso931424a34.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:54:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795290847; cv=none;
        d=google.com; s=arc-20260327;
        b=LWXullejEPr24xjXk7PlYVwRS5t5QqKm+jCMv4mYfWAbA6mpypWUsjhUvFgqNifNVz
         caI/eKzD+1UDSgVJ8bTDY4HkajSfthKtGlG2I9Yw+a38ZRuzPXzRyqn7eTgv+yOdO5Bu
         ++RmCqjmTa55rhpG5br92VlAUSc/+HBFyFR/PGzsiIqTUwnBM/0l1B+JOc5GUnr3nY71
         R+YwwkwpeFRqatu7OHmF/Ppe8rCMJvT4Qcos65ReXpoVXowMpx3YKPifB3jIR6SaWUh7
         5cdwTfY5LO+ebdsLTC+sWgAMK6Jo5F6nFYnJ7KxZBFA8UjanNOdsN2aqTO8Hsxd5ufM8
         e+TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=d1sN2fGHBg+DK42ooMw+OHw6UPh+x8wf0X6rkFNTrGI=;
        fh=94rbW3oDfxko+1hm++NLiavzp5ntnklPEmGXISm1FLM=;
        b=HkHgXQ/rzxb+x10iXMPEqxSSnLHmDW5OxuRw/wSl5wUCoIuhEgbQpfzF+J6x/AH0qb
         PvoIt7GlPlpO4nuS8hq1OJIHyGrG2QflvKZ8te+PfrpMW2IM+DVJQBNMYpHMKWjzHLgG
         K/Q5T91wsaTPbFZtDPYNd5irMFBIyAwRZdzYsa2uVyDhB7EtwR4KEwlbof1v8npCraNV
         YByLfcznLlAhiVhmnpRPFDKIyoU+L/B5h37TG7PdXmCKyp5+kfSEAd0QAh4oHSoM+pXy
         4Vh4zh5cc1XH6xi9IXRyaQFqVOjsLjsT4LChYotRwlX+dRXKkWz0PMQH+wl/OJiMcWNw
         aH/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795290847; x=1795895647; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d1sN2fGHBg+DK42ooMw+OHw6UPh+x8wf0X6rkFNTrGI=;
        b=HuPyUqUk3mSu6UYk5vR6ZKV2JH8Z+Ff0X1EofK0deM/ACrKdTZ5kgNwX3+dHCQBiDw
         Orf0OPnHlCjC7gM9E6QL5nfPcklB9DFCxMRrslJs9zHqldqo08mQHonA7Yv3jDiXjwqB
         HQsDUb21kiBGr656TSFLMrkjvahvEHq8TBWj5oKfk0KCnYiCrib9Lo3UBGasQolLj2bS
         8wad1sTBSjT5BHO56bhybZw0tKAukxvdnChSzcynQjSYRhZa3W++RsSF4njwWuTY+49V
         qgtd8eok4YLJaRq0APvTm/hHnDFh+S1smqh+mj+uuP3DHmJQAuhdJ/tE833BKhFy6iQy
         BIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795290847; x=1795895647;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d1sN2fGHBg+DK42ooMw+OHw6UPh+x8wf0X6rkFNTrGI=;
        b=lIk8zSmrQmVPauBIa6EKKg7boncglUgEYDZAiyG0JE+ocgE0B+l4LpasbqG+N90ciK
         HuDxQPBDZqGQnF4EOnoMJpSbqDfL7QfxhoJXkeSfqfs6wL11BFfTNhxNet0tc/cdZ1MH
         8ccdASfPqLCh3yJQ9HNiF9+BkhCz10XOcYTQDfp+QGWb6Zake+e/F5xXyZ3tPi3KsIP3
         49UnHPiMR0TPF3X4fDNh1bsAoGWpWZGqz55ZTQrMmhCg78/zr9/dElnnKlnsqOBbA2Zs
         9y68G2djncidefnjjhXnIGgg3dixa+/LdhZ5+YiEce+6NdSQnVSOzZkFWrR86AYDnvtq
         rQwQ==
X-Forwarded-Encrypted: i=1; AL+hErGxO2+a6HOu3ervkDxmudz0KlJzr2ccSugvUD2qPxdhV7z0nLrw3bbaWLD6mEpFUWPUSeKXCtZNRQ==@kvack.org
X-Gm-Message-State: APuU4Z+l4sIXnMjKDxvop/nUgyJy4IDwpzZx31bfeyCsjYVNni5qUPya
	v4M8dLDiUV4L2184r///Z20DsDPBd4NUVSkxkgwii0KzyaOUesH7Q4T5TI5hSavtieZQivQznJV
	7hAS0p45qfr7evHPfLQ6XYna0yuOdFys=
X-Gm-Gg: AZFdTZcxtYwREv884WP3n2CcLXW2I2IHDRXdLoqBHbDJ2pPPv2vYbm1Ah1cxGFkWxxx
	IPVr2DjPVlwb0asac+Y47qwFuV01sFrixnZSjKdmL1JS+gpypLsUQDUk2sba7YAuT9uD4au6wuu
	KDsGUJnExs+hp6cZ7UBZJ9fC7ddApidEeEnDLVd+4EjT9P0O9OutV1qe9U1zFiURxRCW4swGC7f
	f6MHETvu+o5teENogMjq3Qp/HpbQft29+TYInsT6i/BSNhmKyqumg9fnUTw75Jn/FIrXa+ohb7S
	AXD84DsMacgKrn0zatqSwcaXKtN/qeXC2bEOZH+3oI6yuSqGzbXZqNwpoBQzjO1XMEtpcX0zYdQ
	QOXS0QlNMNFLXYYN7vFkt566CrNO8bWyEZvsG
X-Received: by 2002:a05:6830:412a:b0:862:a48e:24e0 with SMTP id
 46e09a7af769-8631598c215mr7366042a34.17.1795290847284; Sat, 21 Nov 2026
 11:54:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local> <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
In-Reply-To: <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sat, 21 Nov 2026 19:53:54 +0000
X-Gm-Features: Aa3M54rx1WE-eh_N_yvMS_3oQPZ6L5Jrg8YxPuFxTpWtz7t1OppYd2KzpokgdeM
Message-ID: <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
To: Borislav Petkov <bp@alien8.de>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com, 
	mchehab@kernel.org, ashok.raj@oss.qualcomm.com, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: multipart/mixed; boundary="00000000000038ad8a0660ceb900"
X-Rspam-User:
X-Rspamd-Queue-Id: 71F49C0005
X-Stat-Signature: cpxyxefnkr67q8j51kenpgbueryepe43
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795290848-413756
X-HE-Meta: U2FsdGVkX18ygv4v10rt1dBOlBC5qJtfjAw/ZiqPoxgCBx0XAfPqORrRV3XT9s04gjPIbnzz/hnIMkXIYmjpBTgb37RZZ3P/0ox48XAVdokhH9iw5O+TrRUcCTcQ+dcdHFv+UEW/4HIaGELL72W+0nKsMD08wbwWQBhrhEFGzqAF32ch6LAMj6rspLfzrOJVjHMx73EGAiZNfSHVAuZS5OqYf4lmRPowBQn23/k5nRIXOTD+yw6S2x2G3jr4dAbs6IxExTsD2f17FEs9n4Cm6oU3bWyHVMKuVj1y/h174+cVEz4sLvSgG0rYb6svrMJ64O6VsGndZYAkZKkzGaSXlMdEid3IOoqLSlrxTlE6VtJF+H/Vv+BpFp9pMMrlyIKSN7VXtBI72uzTlfGON4/DfkDV3TKEGEjCYiSeCjlxK22yymICLpPC8C7PeYqz1H59OVtWDHYt/LHyrag5YhuZeN4sqj92FOW714MW7+AuvWyteNX1D2OhAYEtlGgzu7wAvQ67vHMSJ8u2c8PPrezOOWWIQ3+JJp1AW+SRUoJnZvygtJ3QZyPUTX8IJ4mqAzEKrjjqsjHKY7lvuButFGwybTNPsq+ecv1nwOGmDK4iH98DBY138H6c0q5f3RxnqOB4+ZTkzBSKpYz968DHNvG+KZcP3TcYqK2/tNnMAG9j/GHVsd+5+inmXAyWRmXT4sZY2M2YfQVoLZVEMPgALsNG5WJWCVUcVgpBEr0G5Hdoksg+w5q9TQDwX0u49ArX5ascjpOQuFcU8tMJdFNJ2XNhFQeGvuSKqWtAY6lLW+VKZ+4zpxPueR6HlJSF02V2MHrV+uxH//6bNSPkB6LRubgymCcuaawuPnaIKfHx1PkJMoz/bLRYB8dRry8MwxG0vr1v1tHGkl0Inwv3A7gVVSl33qijODJzNyphTU2cFsqooHzbpZ5whaUwvJM8IxJgTKnyMUrlBpIe8WhnH+mLYCX
 WMqkcOvI
 6RJXGb+YXpEa5AQzHDkzWiOr/5hiOoHx9mkxf7Yq6JDyQa8RjD9U1JOUtT9Ref1qWi89p74HScvsJQjmKn9tM77krlhKc78FrIlNwbiOi58SvRFyV9oOd0jFa4HZDvGQHK0M181WaIXD1S8TWS51uk4PhwEos/vGQXto0XFLwqnqG+LLK6Lpl4739ZeUt69WWpTY9QM7nn9vbR/8amNRJbdvi32AdeUj84cnwX0a0ac6L5SDE1hi0Gegd6WBgeQeVUFKtOryo/DPIzvO983iPXpkZPbADTznTUNToYe0PBY3moP0ZXK5fiLuncH3qguFOp/Dyu1fy28Ihe9IE3MqJt8GQtXaD4AWBYlL8QU8mH8uylmYzv/RX3VCAqEzSrqC+2SnD5GUPmwrntuVEjleUT+h2qUMfcZ9YOBlMdAQBBncBk47cWFYL/me+Oaf35pEGD2LplCRAzu7VlW7afn2mBodoWUPN1aDpXtYvH53eCj1Xush6fA7e9/NWUJ1qGvwl27GP87Xk4FL+brqWTtyvJgwClh518ZD0qVa0ALAvUx3C6+fnqLr2655iTuMkCa/Kd3eNarLwzg1gn1jz+tVEKp7f1Tp9rUV0OHqJDm5cxNnWyV3XFEsr0Ag/3riq+IqBcKl5OP7qY5CYvwa0suh3ihB9f0pJGUInCZa/uTsguzofkLp6POWBtKaQAcGQ5+yL2nexyQ65wcZApVOjtBYPQWSVEU0FoOuMtoUXOx3pOKX7H9KvM1BlUCJI72CW80kQfuhts2Yyb8Le3ecjXRGTYFsje8BA7sS2u2yfN+e+bYYEZHNXBycJZbQdKELnk3sVIxfYKz5JigyDF4b02QBeMtH0g1Eh0jqsJ7+lViZ2DuNPtRGHdGpW2W1e+AJZVQqGsHZWh6Hq5nV1FDFpaQ0VuZ3pUo6QDV8D/XDMagFvEACZSf+y2AOzd+M8YuwD9rKDRjkTUEHY9fvAi1e8narVnLGr+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--00000000000038ad8a0660ceb900
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 21, 2026 at 7:41=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Tue, Nov 10, 2026 at 11:00:45PM +0000, Shiju Jose wrote:
> > I am sharing the changes in patch#2 here for feedback while testing on
> > other platforms.
>
> This doesn't apply. You can attach the diff so that I can fold it in.
>
> Thx.
Hi Boris,

Please find the attached patch with the changes.

Thanks,
Shiju

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

--00000000000038ad8a0660ceb900
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ras-mem-Replace-ioread8-16-32-64-with-readb-w-l-q-io.patch"
Content-Disposition: attachment; 
	filename="0001-ras-mem-Replace-ioread8-16-32-64-with-readb-w-l-q-io.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mwqtouuq0>
X-Attachment-Id: f_mwqtouuq0

RnJvbSBkNTA0ZDYxYTE3ZDQ2YjBhYTExNDFiNWQxY2Y4MjhmYWNiNjdlZWY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaGlqdSBKb3NlIDxzaGlqdWpvc2UyMDA4QGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAxMCBOb3YgMjAyNiAyMjo0ODo1MiArMDAwMApTdWJqZWN0OiBbUEFUQ0ggMS8x
XSByYXM6IG1lbTogUmVwbGFjZSBpb3JlYWQ4LzE2LzMyLzY0IHdpdGggcmVhZGIvdy9sL3EgJgog
aW93cml0ZTgvMTYvMzIvNjQgd2l0aCB3cml0ZWIvdy9sL3EKClg4Ni02NCBidWlsZCBmYWlsZWQg
d2l0aCBpb3JlYWQ2NCBhbmQgaW93cml0ZTY0IGFyZSBub3QgZGVmaW5lZC4KClRvIGZpeCB0aGlz
IGlzc3VlIHJlcGxhY2UgaW9yZWFkOC8xNi8zMi82NCB3aXRoIHJlYWRiL3JlYWR3L3JlYWRsL3Jl
YWRxIGFuZAppb3dyaXRlOC8xNi8zMi82NCB3aXRoIHdyaXRlYi93cml0ZXcvd3JpdGVsL3dyaXRl
cSByZXNwZWN0aXZlbHkuCi0tLQogZHJpdmVycy9yYXMvYWNwaV9yYXMyLmMgfCA1NiArKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI4IGlu
c2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcmFzL2Fj
cGlfcmFzMi5jIGIvZHJpdmVycy9yYXMvYWNwaV9yYXMyLmMKaW5kZXggNTFhZGZjZGRmYTk5Li4w
ODQ5ZGQyNDdjYWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcmFzL2FjcGlfcmFzMi5jCisrKyBiL2Ry
aXZlcnMvcmFzL2FjcGlfcmFzMi5jCkBAIC01MSw5ICs1MSw5IEBAIHN0YXRpYyBpbnQgcmFzMl9p
c19wYXRyb2xfc2NydWJfc3VwcG9ydChzdHJ1Y3QgcmFzMl9tZW1fY3R4ICpyYXMyX2N0eCkKIAlz
dHJ1Y3QgYWNwaV9yYXMyX3NobWVtIF9faW9tZW0gKmNvbW1vbiA9ICh2b2lkICopcmFzMl9jdHgt
PmNvbW1fYWRkcjsKIAogCWd1YXJkKG11dGV4KShyYXMyX2N0eC0+cGNjX2xvY2spOwotCWlvd3Jp
dGU4KDAsICZjb21tb24tPnNldF9jYXBzWzBdKTsKKwl3cml0ZWIoMCwgJmNvbW1vbi0+c2V0X2Nh
cHNbMF0pOwogCi0JcmV0dXJuIGlvcmVhZDgoJmNvbW1vbi0+ZmVhdHVyZXNbMF0pICYgUkFTMl9T
VVBQT1JUX0hXX1BBUlRPTF9TQ1JVQjsKKwlyZXR1cm4gcmVhZGIoJmNvbW1vbi0+ZmVhdHVyZXNb
MF0pICYgUkFTMl9TVVBQT1JUX0hXX1BBUlRPTF9TQ1JVQjsKIH0KIAogc3RhdGljIGludCByYXMy
X3VwZGF0ZV9wYXRyb2xfc2NydWJfcGFyYW1zX2NhY2hlKHN0cnVjdCByYXMyX21lbV9jdHggKnJh
czJfY3R4KQpAQCAtNjMsMTcgKzYzLDE3IEBAIHN0YXRpYyBpbnQgcmFzMl91cGRhdGVfcGF0cm9s
X3NjcnViX3BhcmFtc19jYWNoZShzdHJ1Y3QgcmFzMl9tZW1fY3R4ICpyYXMyX2N0eCkKIAl1MzIg
c2NydWJfcGFyYW1zX291dDsKIAlpbnQgcmV0OwogCi0JaW93cml0ZTgoUkFTMl9TVVBQT1JUX0hX
X1BBUlRPTF9TQ1JVQiwgJnBzX3NtLT5jb21tb24uc2V0X2NhcHNbMF0pOwotCWlvd3JpdGUxNihS
QVMyX0dFVF9QQVRST0xfUEFSQU1FVEVSUywgJnBzX3NtLT5wYXJhbXMuY29tbWFuZCk7Ci0JaW93
cml0ZTY0KHJhczJfY3R4LT5tZW1fYmFzZSwgJnBzX3NtLT5wYXJhbXMucmVxX2FkZHJfcmFuZ2Vb
MF0pOwotCWlvd3JpdGU2NChyYXMyX2N0eC0+bWVtX3NpemUsICZwc19zbS0+cGFyYW1zLnJlcV9h
ZGRyX3JhbmdlWzFdKTsKKwl3cml0ZWIoUkFTMl9TVVBQT1JUX0hXX1BBUlRPTF9TQ1JVQiwgJnBz
X3NtLT5jb21tb24uc2V0X2NhcHNbMF0pOworCXdyaXRldyhSQVMyX0dFVF9QQVRST0xfUEFSQU1F
VEVSUywgJnBzX3NtLT5wYXJhbXMuY29tbWFuZCk7CisJd3JpdGVxKHJhczJfY3R4LT5tZW1fYmFz
ZSwgJnBzX3NtLT5wYXJhbXMucmVxX2FkZHJfcmFuZ2VbMF0pOworCXdyaXRlcShyYXMyX2N0eC0+
bWVtX3NpemUsICZwc19zbS0+cGFyYW1zLnJlcV9hZGRyX3JhbmdlWzFdKTsKIAlyZXQgPSByYXMy
X3NlbmRfcGNjX2NtZChyYXMyX2N0eCwgUENDX0NNRF9FWEVDX1JBUzIpOwogCWlmIChyZXQpIHsK
IAkJZGV2X2VycihyYXMyX2N0eC0+ZGV2LCAiRmFpbGVkIHRvIHJlYWQgcGF0cm9sIHNjcnViIHBh
cmFtZXRlcnNcbiIpOwogCQlyZXR1cm4gcmV0OwogCX0KIAotCXNjcnViX3BhcmFtc19vdXQgPSBp
b3JlYWQzMigmcHNfc20tPnBhcmFtcy5zY3J1Yl9wYXJhbXNfb3V0KTsKKwlzY3J1Yl9wYXJhbXNf
b3V0ID0gcmVhZGwoJnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX291dCk7CiAJcmFzMl9jdHgt
Pm1pbl9zY3J1Yl9jeWNsZSA9IEZJRUxEX0dFVChSQVMyX1BTX01JTl9TQ19IUlNfT1VUX01BU0ss
CiAJCQkJCSAgICAgIHNjcnViX3BhcmFtc19vdXQpOwogCXJhczJfY3R4LT5tYXhfc2NydWJfY3lj
bGUgPSBGSUVMRF9HRVQoUkFTMl9QU19NQVhfU0NfSFJTX09VVF9NQVNLLApAQCAtOTQsMTAgKzk0
LDEwIEBAIHN0YXRpYyBpbnQgcmFzMl91cGRhdGVfcGF0cm9sX3NjcnViX3BhcmFtc19jYWNoZShz
dHJ1Y3QgcmFzMl9tZW1fY3R4ICpyYXMyX2N0eCkKIAkJcmV0dXJuIDA7CiAJfQogCi0JaWYgIChp
b3JlYWQzMigmcHNfc20tPnBhcmFtcy5mbGFncykgJiBSQVMyX1BTX0ZMQUdfU0NSVUJfUlVOTklO
RykgeworCWlmICAocmVhZGwoJnBzX3NtLT5wYXJhbXMuZmxhZ3MpICYgUkFTMl9QU19GTEFHX1ND
UlVCX1JVTk5JTkcpIHsKIAkJcmFzMl9jdHgtPm9kX3NjcnViID0gdHJ1ZTsKLQkJcmFzMl9jdHgt
PmJhc2UgPSBpb3JlYWQ2NCgmcHNfc20tPnBhcmFtcy5hY3RsX2FkZHJfcmFuZ2VbMF0pOwotCQly
YXMyX2N0eC0+c2l6ZSA9IGlvcmVhZDY0KCZwc19zbS0+cGFyYW1zLmFjdGxfYWRkcl9yYW5nZVsx
XSk7CisJCXJhczJfY3R4LT5iYXNlID0gcmVhZHEoJnBzX3NtLT5wYXJhbXMuYWN0bF9hZGRyX3Jh
bmdlWzBdKTsKKwkJcmFzMl9jdHgtPnNpemUgPSByZWFkcSgmcHNfc20tPnBhcmFtcy5hY3RsX2Fk
ZHJfcmFuZ2VbMV0pOwogCX0gZWxzZSB7CiAJCXJhczJfY3R4LT5vZF9zY3J1YiA9IGZhbHNlOwog
CX0KQEAgLTEyOCw3ICsxMjgsNyBAQCBzdGF0aWMgaW50IHJhczJfZ2V0X2RlbWFuZF9zY3J1Yl9y
dW5uaW5nKHN0cnVjdCByYXMyX21lbV9jdHggKnJhczJfY3R4LCBib29sICpydQogCQlyZXR1cm4g
cmV0OwogCX0KIAotCSpydW5uaW5nID0gaW9yZWFkMzIoJnBzX3NtLT5wYXJhbXMuZmxhZ3MpICYg
UkFTMl9QU19GTEFHX1NDUlVCX1JVTk5JTkc7CisJKnJ1bm5pbmcgPSByZWFkbCgmcHNfc20tPnBh
cmFtcy5mbGFncykgJiBSQVMyX1BTX0ZMQUdfU0NSVUJfUlVOTklORzsKIAlpZiAoISgqcnVubmlu
ZykpCiAJCXJhczJfY3R4LT5vZF9zY3J1YiA9IGZhbHNlOwogCkBAIC0zMzgsMTggKzMzOCwxOCBA
QCBzdGF0aWMgaW50IF9fcmFzMl9od19zY3J1Yl9zZXRfZW5hYmxlZF9iZyhzdHJ1Y3QgZGV2aWNl
ICpkZXYsIHZvaWQgKmRydl9kYXRhLCBibwogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKLQlp
b3dyaXRlOChSQVMyX1NVUFBPUlRfSFdfUEFSVE9MX1NDUlVCLCAmcHNfc20tPmNvbW1vbi5zZXRf
Y2Fwc1swXSk7CisJd3JpdGViKFJBUzJfU1VQUE9SVF9IV19QQVJUT0xfU0NSVUIsICZwc19zbS0+
Y29tbW9uLnNldF9jYXBzWzBdKTsKIAlpZiAoZW5hYmxlKSB7CiAJCWlmIChyYXMyX2N0eC0+Ymdf
c2NydWIgfHwgcnVubmluZykKIAkJCXJldHVybiAtRUJVU1k7CiAKLQkJaW93cml0ZTY0KDAsICZw
c19zbS0+cGFyYW1zLnJlcV9hZGRyX3JhbmdlWzBdKTsKLQkJaW93cml0ZTY0KDAsICZwc19zbS0+
cGFyYW1zLnJlcV9hZGRyX3JhbmdlWzFdKTsKLQkJc2NydWJfcGFyYW1zX2luID0gaW9yZWFkMzIo
JnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX2luKTsKKwkJd3JpdGVxKDAsICZwc19zbS0+cGFy
YW1zLnJlcV9hZGRyX3JhbmdlWzBdKTsKKwkJd3JpdGVxKDAsICZwc19zbS0+cGFyYW1zLnJlcV9h
ZGRyX3JhbmdlWzFdKTsKKwkJc2NydWJfcGFyYW1zX2luID0gcmVhZGwoJnBzX3NtLT5wYXJhbXMu
c2NydWJfcGFyYW1zX2luKTsKIAkJc2NydWJfcGFyYW1zX2luICY9IH5SQVMyX1BTX1NDX0hSU19J
Tl9NQVNLOwogCQlzY3J1Yl9wYXJhbXNfaW4gfD0gRklFTERfUFJFUChSQVMyX1BTX1NDX0hSU19J
Tl9NQVNLLCByYXMyX2N0eC0+c2V0X3NjcnViX2N5Y2xlKTsKLQkJaW93cml0ZTMyKHNjcnViX3Bh
cmFtc19pbiwgJnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX2luKTsKLQkJaW93cml0ZTE2KFJB
UzJfU1RBUlRfUEFUUk9MX1NDUlVCQkVSLCAmcHNfc20tPnBhcmFtcy5jb21tYW5kKTsKKwkJd3Jp
dGVsKHNjcnViX3BhcmFtc19pbiwgJnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX2luKTsKKwkJ
d3JpdGV3KFJBUzJfU1RBUlRfUEFUUk9MX1NDUlVCQkVSLCAmcHNfc20tPnBhcmFtcy5jb21tYW5k
KTsKIAl9IGVsc2UgewogCQkvKgogCQkgKiBUaGVyZSBpcyBubyBuZWVkIHRvIHNlbmQgdGhlIGNv
bW1hbmQgdG8gc3RvcCBiYWNrZ3JvdW5kIHNjcnViYmluZywKQEAgLTM1OCwxMyArMzU4LDEzIEBA
IHN0YXRpYyBpbnQgX19yYXMyX2h3X3NjcnViX3NldF9lbmFibGVkX2JnKHN0cnVjdCBkZXZpY2Ug
KmRldiwgdm9pZCAqZHJ2X2RhdGEsIGJvCiAJCWlmICghcmFzMl9jdHgtPmJnX3NjcnViKQogCQkJ
cmV0dXJuIC1FUEVSTTsKIAotCQlpb3dyaXRlMTYoUkFTMl9TVE9QX1BBVFJPTF9TQ1JVQkJFUiwg
JnBzX3NtLT5wYXJhbXMuY29tbWFuZCk7CisJCXdyaXRldyhSQVMyX1NUT1BfUEFUUk9MX1NDUlVC
QkVSLCAmcHNfc20tPnBhcmFtcy5jb21tYW5kKTsKIAl9CiAKLQlzY3J1Yl9wYXJhbXNfaW4gPSBp
b3JlYWQzMigmcHNfc20tPnBhcmFtcy5zY3J1Yl9wYXJhbXNfaW4pOworCXNjcnViX3BhcmFtc19p
biA9IHJlYWRsKCZwc19zbS0+cGFyYW1zLnNjcnViX3BhcmFtc19pbik7CiAJc2NydWJfcGFyYW1z
X2luICY9IH5SQVMyX1BTX0VOX0JBQ0tHUk9VTkQ7CiAJc2NydWJfcGFyYW1zX2luIHw9IEZJRUxE
X1BSRVAoUkFTMl9QU19FTl9CQUNLR1JPVU5ELCBlbmFibGUpOwotCWlvd3JpdGUzMihzY3J1Yl9w
YXJhbXNfaW4sICZwc19zbS0+cGFyYW1zLnNjcnViX3BhcmFtc19pbik7CisJd3JpdGVsKHNjcnVi
X3BhcmFtc19pbiwgJnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX2luKTsKIAlyZXQgPSByYXMy
X3NlbmRfcGNjX2NtZChyYXMyX2N0eCwgUENDX0NNRF9FWEVDX1JBUzIpOwogCWlmIChyZXQpIHsK
IAkJZGV2X2VycihkZXYsICJGYWlsZWQgdG8gJXMgYmFja2dyb3VuZCBzY3J1YmJpbmdcbiIsCkBA
IC00NDksMjIgKzQ0OSwyMiBAQCBzdGF0aWMgaW50IHJhczJfaHdfc2NydWJfc2V0X2VuYWJsZWRf
b2Qoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkICpkcnZfZGF0YSwgYm9vbAogCQlnb3RvIGVuYWJs
ZV9iZ19zY3J1YjsKIAl9CiAKLQlpb3dyaXRlOChSQVMyX1NVUFBPUlRfSFdfUEFSVE9MX1NDUlVC
LCAmcHNfc20tPmNvbW1vbi5zZXRfY2Fwc1swXSk7Ci0Jc2NydWJfcGFyYW1zX2luID0gaW9yZWFk
MzIoJnBzX3NtLT5wYXJhbXMuc2NydWJfcGFyYW1zX2luKTsKKwl3cml0ZWIoUkFTMl9TVVBQT1JU
X0hXX1BBUlRPTF9TQ1JVQiwgJnBzX3NtLT5jb21tb24uc2V0X2NhcHNbMF0pOworCXNjcnViX3Bh
cmFtc19pbiA9IHJlYWRsKCZwc19zbS0+cGFyYW1zLnNjcnViX3BhcmFtc19pbik7CiAJc2NydWJf
cGFyYW1zX2luICY9IH5SQVMyX1BTX1NDX0hSU19JTl9NQVNLOwogCXNjcnViX3BhcmFtc19pbiB8
PSBGSUVMRF9QUkVQKFJBUzJfUFNfU0NfSFJTX0lOX01BU0ssIHJhczJfY3R4LT5zZXRfc2NydWJf
Y3ljbGUpOwogCXNjcnViX3BhcmFtc19pbiAmPSB+UkFTMl9QU19FTl9CQUNLR1JPVU5EOwotCWlv
d3JpdGUzMihzY3J1Yl9wYXJhbXNfaW4sICZwc19zbS0+cGFyYW1zLnNjcnViX3BhcmFtc19pbik7
Ci0JaW93cml0ZTY0KHJhczJfY3R4LT5iYXNlLCAmcHNfc20tPnBhcmFtcy5yZXFfYWRkcl9yYW5n
ZVswXSk7Ci0JaW93cml0ZTY0KHJhczJfY3R4LT5zaXplLCAmcHNfc20tPnBhcmFtcy5yZXFfYWRk
cl9yYW5nZVsxXSk7Ci0JaW93cml0ZTE2KFJBUzJfU1RBUlRfUEFUUk9MX1NDUlVCQkVSLCAmcHNf
c20tPnBhcmFtcy5jb21tYW5kKTsKKwl3cml0ZWwoc2NydWJfcGFyYW1zX2luLCAmcHNfc20tPnBh
cmFtcy5zY3J1Yl9wYXJhbXNfaW4pOworCXdyaXRlcShyYXMyX2N0eC0+YmFzZSwgJnBzX3NtLT5w
YXJhbXMucmVxX2FkZHJfcmFuZ2VbMF0pOworCXdyaXRlcShyYXMyX2N0eC0+c2l6ZSwgJnBzX3Nt
LT5wYXJhbXMucmVxX2FkZHJfcmFuZ2VbMV0pOworCXdyaXRldyhSQVMyX1NUQVJUX1BBVFJPTF9T
Q1JVQkJFUiwgJnBzX3NtLT5wYXJhbXMuY29tbWFuZCk7CiAKIAlyZXQgPSByYXMyX3NlbmRfcGNj
X2NtZChyYXMyX2N0eCwgUENDX0NNRF9FWEVDX1JBUzIpOwogCWlmIChyZXQpIHsKIAkJZGV2X2Vy
cihkZXYsICJGYWlsZWQgdG8gc3RhcnQgZGVtYW5kIHNjcnViYmluZyByYyglZClcbiIsIHJldCk7
CiAJCWlmIChyZXQgIT0gLUVCVVNZKSB7Ci0JCQlpb3dyaXRlNjQoMCwgJnBzX3NtLT5wYXJhbXMu
cmVxX2FkZHJfcmFuZ2VbMF0pOwotCQkJaW93cml0ZTY0KDAsICZwc19zbS0+cGFyYW1zLnJlcV9h
ZGRyX3JhbmdlWzFdKTsKKwkJCXdyaXRlcSgwLCAmcHNfc20tPnBhcmFtcy5yZXFfYWRkcl9yYW5n
ZVswXSk7CisJCQl3cml0ZXEoMCwgJnBzX3NtLT5wYXJhbXMucmVxX2FkZHJfcmFuZ2VbMV0pOwog
CQkJcmFzMl9jdHgtPm9kX3NjcnViID0gZmFsc2U7CiAJCQlyYXMyX2N0eC0+YmFzZSA9IDA7CiAJ
CQlyYXMyX2N0eC0+c2l6ZSA9IDA7Ci0tIAoyLjI1LjEKCg==
--00000000000038ad8a0660ceb900--

