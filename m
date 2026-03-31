Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF3FFF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3436D6B009D; Tue, 31 Mar 2026 05:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3926B009E; Tue, 31 Mar 2026 05:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231406B009F; Tue, 31 Mar 2026 05:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126F96B009D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:40:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C45C58CD17
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:32 +0000 (UTC)
X-FDA: 84605863104.10.A7D612D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 36BE0C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7HQNcqp;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7HQNcqp;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950031; a=rsa-sha256;
	cv=none;
	b=LLPGdjT3mWLhFfypWQb7A79y0TWR4uerUzgB9bBlbC/3dcRyf4ZcCof3VhRb6GJS5NjBUu
	V9SKBBsSld9dwhQjJNvyHLhYDdM2gGgFjrgqMbCBnI7EfVqGO3WKGcEOEMS98Wkm7cu5Xg
	4t08Nw1iMB64Db8l2hjMRjqDqPGiP6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9naS+R4VQov6ydeWsVeCcOj9RZa8RGSTTuVF34+pHlo=;
	b=XcMXjB8zqRv1RpzbA68YKKH64XMkcv9dw5pSVW55NF/tYcrFVuR0BAzR4Ct8n7J0CZ6C2Z
	R4QN902idIDhW/3xE6wLGs+c3R93gAv2ReJPzXLjgEQUzWugrgC3hhfKP7l22joh/dOdcq
	qe+JyNzGGdXJv+XJNOlYF9+7t1KuQ8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B00FB60120;
	Tue, 31 Mar 2026 09:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F1EC19423;
	Tue, 31 Mar 2026 09:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950030;
	bh=T7KhY3GM2hmdjQuBjDcNWz4pOtoqYT5vZ5McUEpAqqo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=r7HQNcqpn9km9vbR1ewA1TCeXTJqJ5YhOKdfSl9Xrq34yEDVSVx+YTxeNK/Uyky8y
	 5TbMzyRZnb66iek3LES1wnqZCxRa3vutvlcqBIWxKxNe91zwBSr8+or/0D0tgy2BuR
	 5c9JdJQ9FHa8KeVMJ0wgNyxlbppZZMf070A6pUMyKC4AhK3ZiPOHZp7fw7fiPkxSkw
	 VywV6PEX6tBJ7TcIbsmqToD+pFI+gDx/hUWI0EbDheZjRgL4bMe+v5b5MJnVPb0MZE
	 AZYYCvF9/AnnBilB1VhytX/2vXFxUKeA12EFKbebFGoWnTCS9U/7Xv5VLx+1Yfkipw
	 Uv4CFZG4cqwLQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
In-Reply-To: <CA+CK2bDJJ2exSz4i3by3QLX1xvLAyqG5L+UipraiQw3Ytmx2=w@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 27 Mar 2026 09:16:19 -0400")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-2-pasha.tatashin@soleen.com>
	<CA+CK2bDJJ2exSz4i3by3QLX1xvLAyqG5L+UipraiQw3Ytmx2=w@mail.gmail.com>
Date: Tue, 31 Mar 2026 09:40:26 +0000
Message-ID: <2vxzmrzoibg5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36BE0C0005
X-Stat-Signature: z1g8c3h7h9byrewmq3tjm6m99dauojuj
X-Rspam-User: 
X-HE-Tag: 1774950031-853472
X-HE-Meta: U2FsdGVkX19P75p4SdWskfuPonL+d4ntinmocT01IpufdbgY73SrrOZomrMGiiG/bo/k9+cffTVduOXxPbmrUMjM+4EQ1WSO7eeo+aZgjooN0tb+dylFxOVWyIVZrGRkHZXIGd8yln0rKK939DW+qTZZ73vSPs3UlEXfNszpujYChHxGn8fEIB69QbovQxY8L3eHHGbFRl9sVZ6S4MBrFbMqtMOrElveF65o3TQHMdhZ74r3zOfRE1xo9X19twLZhiii+ugZ+NPaMruhyN4nNhYY9YBobseowQUlpFvnivBJVoRnsURnu/ws3RJYKvwjhtVxjZuAgulIPQcqNRyDTwYED/Nzc6Eu3Wy+uXxr3aDXZpttyq4v7LebJwuBZQ8G1lfsXAvh/qgKSgHPaNbyichH/GZyFp6hpXqJWbljcLHB9GxkO26UQfKpWT8TQI+Vv6aUynMU8+UO8OnuVl5QpEXvSaFDwooSZ6LyNGYFR548t0CPDGI4gf2wMBvE4Zixj4irSQTAsp9E1S4jg0TDlzmeMAcZmhVqvUCTOOBJdzOBs7mivCjo14Z5xeUuooLbwGhnhDQAsU01UuO1qKZCYzzr+NwCBUoARxhDM1FC/SKcd4IWwFlm9k9yswhp7rLNUB2/zaDWCofSF+pah7aiZO48JDstYIVWfgEFYOpqr6hCrHEppBkrxUMihCUUqSWfNXracVznIBSCmNx+HkqSOolkZXbDWGLa1Kp7N7ANZBiuBq1frquTGsGBYd0mU9w9DIdprEIrkeG1SRbYS0ISNWZZpWAsfYBC/ZTJTT6YS6bh/R0F8Fhoy3zo2TUeGb/eU4gCLEBxA6g2V3KhZTRNJ40LRhuaguDO1BMaYVVicFFfQTDk/uPd+nNTNN0Q2X9fuWIRCxlvYW/V1gXSatm2VvVLbp8lv9+XJRTOS8JQ2iXVUxszl7SCdxKhFSCFegzHiBeGP4AjV0ZDfdBVLHd
 /5LKFimJ
 efhwuEJgSfAg/9VbiHqmZ0JU6FTCOJ8JUDC4LzKrMk/hV7IFKUT5LWT9UDPSwjBsNDaA1JKkEoCC1eT0qgZcHfA5kYYouzf0jiPNCHVaMnaGVVFeIyaYD3QepoWVDYluJmPqqNNVqSiDhPyds53Lbkmjqb7fAD/ni/sSop30UFUnt5LJjbnLGRfLjckfR0vMHn9J0iNDXbte0iSukRZxFTx86Xi6zwbxiOf4rxZuStGAGbd3cuAUFTVMx+LE68OyWDHUyHq5zvKJDZBSDwsQtWa2Xng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> On Thu, Mar 26, 2026 at 11:33=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>> Deserialized strings from KHO data (such as file handler compatible
>> strings and session names) are provided by the previous kernel and
>> might not be null-terminated if the data is corrupted or maliciously
>> crafted.
>>
>> When printing these strings in error messages, use the %.*s format
>> specifier with the maximum buffer size to prevent out-of-bounds reads
>> into adjacent kernel memory.
>>
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  kernel/liveupdate/luo_file.c    | 3 ++-
>>  kernel/liveupdate/luo_session.c | 3 ++-
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index 5acee4174bf0..a6d98fc75d25 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
>> @@ -785,7 +785,8 @@ int luo_file_deserialize(struct luo_file_set *file_s=
et,
>>                 }
>>
>>                 if (!handler_found) {
>> -                       pr_warn("No registered handler for compatible '%=
s'\n",
>> +                       pr_warn("No registered handler for compatible '%=
.*s'\n",
>> +                               (int)sizeof(file_ser[i].compatible),
>>                                 file_ser[i].compatible);
>>                         return -ENOENT;
>>                 }
>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_ses=
sion.c
>> index 25ae704d7787..8c76dece679b 100644
>> --- a/kernel/liveupdate/luo_session.c
>> +++ b/kernel/liveupdate/luo_session.c
>> @@ -544,7 +544,8 @@ int luo_session_deserialize(void)
>>
>>                 session =3D luo_session_alloc(sh->ser[i].name);
>>                 if (IS_ERR(session)) {
>> -                       pr_warn("Failed to allocate session [%s] during =
deserialization %pe\n",
>> +                       pr_warn("Failed to allocate session [%.*s] durin=
g deserialization %pe\n",
>> +                               (int)sizeof(sh->ser[i].name),
>>                                 sh->ser[i].name, session);
>>                         return PTR_ERR(session);
>>                 }
>
> Lol, Sashiko went a little overboard and gave this patch two
> "Critical" findings:
>
> 1. If a registered file handler uses a compatible string equal to or long=
er than
> the buffer, and the untrusted string matches it without a null terminator,
> strcmp() could read past the bounds of file_ser[i].compatible.
>
> B.S.: The length of the string is ABI, and fh->compatible is a
> NULL-terminated string provided by the current kernel. In the future,
> we can replace strcmp() with strncmp(), but it is not a high-priority
> issue.
>
> 2. By returning PTR_ERR(session) directly without updating the static err
> variable, subsequent calls will see is_deserialized as true and return 0.
>
> This is regarding luo_session_deserialize(), that is the intended
> behavior. We attempt deserialization exactly once, and if it fails,
> some resources stay "leaked" and inaccessible to the user until the
> next reboot. This is the safest approach to avoid data leaks.

I think you misunderstood. Sashiko brings up a very good point. The
problem is not that we don't attempt the deserialization again, the
problem is that this code path doesn't set err.

So this results in is_deserialized =3D=3D true, but err =3D=3D 0 even though
deserialization failed. So the next attempt to open /dev/liveupdate will
succeed since

	if (is_deserialized)
		return err;

will return 0. So I think you need to do:

	err =3D PTR_ERR(session);
	return err;

To make sure this error code gets recorded and the next open of
/dev/liveupdate also fails.

Anyway, this isn't directly related to this patch but it is a real bug
that should be fixed in a separate patch.

--=20
Regards,
Pratyush Yadav

