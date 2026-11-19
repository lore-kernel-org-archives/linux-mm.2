Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAC8606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 21:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H15TN2tl
Received: by kanga.kvack.org (Postfix)
	id 39BDF6B0614; Thu, 19 Nov 2026 16:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C796B06EE; Thu, 19 Nov 2026 16:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BF66B06E0; Thu, 19 Nov 2026 16:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E01226B06EE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:47:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 502DEC0AFE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:47:25 +0000 (UTC)
X-FDA: 85453205250.21.E57D69E
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 778F214000E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:47:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H15TN2tl;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795124843;
	b=7RTyiP798Hm25lnV0jCL8M3upDRty8vrWVmHCcgRawvBtH9Egv6Nk7SXR/60Iu3imLnDi/
	cy9ZK1FtZcbM9TQOftMpYCVjNwJnf5nwLROw0q+6sMw+PplHg+Oq8MxZulSNCS7RJMDdCs
	364Kyecl7asnR3metbdYczQZPCEzQ14=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795124843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L7EofMK/Ds2aCpVQ+mBzdmSBmTPWhoy8WE97V8cVUk4=;
	b=y0d1ChbjBNDCooDcvFlloh375sWydQQZi6SY5IDo4rXkPcg46nNma1h7MQuJ9FZdj9FfTL
	BRaL/9nUz80N/efYTJPJrohp/uVshsHXdC2H75AGcx1VbgZzsu02pbCxrPvV0YWbHtpwr5
	J6TbTg0jfXXyKILjtRBme5Yh6+YSwfs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H15TN2tl;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-92110499585so3587876d6.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:47:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795124842; cv=none;
        d=google.com; s=arc-20260327;
        b=CxTyA9xbDnW+EtZH9AA0ULU8evZaVX6pUOnff5O/ZDnJI/P9WbiFKeQa6SrwnfuNUr
         dSYgwZEktTibYfdUhrKrYmplh6uRkcRX0vHGxGh6pCcsKbz0UNF2oYSxE3GhTB323sLo
         Wryr1gjfGuGUmmjzWEVBsO3d4PQpmkPJjKZzXbDQu3OO2TL5a4TueStEpKDIVRg5z6Kc
         ZHN9t48qA1erJFiOftlEBcVtbnfLlBHM8VtMS+r3ROpXGaQyxJ+DUBvA1l9VrekSK30B
         GyxZAeRaLx9ONWRXvQb7XjyOpvCxsgH9qPdcU0KM708xU8TYMG4iYrEzCuonom8QAoLc
         0eRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=L7EofMK/Ds2aCpVQ+mBzdmSBmTPWhoy8WE97V8cVUk4=;
        fh=zwQ6UFIko0p2lptumoP2z5Dpbq0qCW7QScDWIKfk1N0=;
        b=qVhEoVF4CGIofsqa7O02nLBiOftd+N5FkihBqogUyaR9qenboeMrBqz2ULjs5tZLWS
         op1VfFyrv8fQrYoJ3Kynf+UflqIPGG5XMwWUgYpduy6OgcPXIFgTbdvNiuobTXz3OusG
         kxNIv3q+4QtGO9Uzmk8Ldo23Htq3c7AfVHKRzdpLetPFm3/vCKFZQP0frYL7tYNbFy8M
         emjFSsSG+9kYW8I+HgG5ua1EFBraNl1dkiLbrdqIglKzyisUcGb2zPIzRTu3W3d4Jceu
         Ez+jXZURVh+CaHV2Fyeei3T4QmnYm9gCkBW/t0U36kanU48W7KOaxqQXmJlOW5NSNt7C
         H4eA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795124842; x=1795729642; darn=kvack.org;
        h=content-type:to:subject:message-id:date:mime-version:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=L7EofMK/Ds2aCpVQ+mBzdmSBmTPWhoy8WE97V8cVUk4=;
        b=H15TN2tl8SEvwpJGD5Mk6Gktj2xe9QeaaVjn1hxAg8cwMxmTBCFtNgWrtCAqsBD3aI
         KUBnLx1dptt58ZwJ5tyQuhF4GHp8upCEiMhJXt8apFDhVk6mlJeNLqfigCcErccWI0Q2
         XHG/QV3OvoFE/eU9dn4Geg/2ms1mLoXTyhJnz+v0DRaE/d8wYRgBm6qpf/xkL/gfTF85
         lkdzVBybMtMrpi7UdEFNZj+1nC8HCga8uQf/npm+s2juIleKxVt0jOiMbI/3IbrFrD2o
         ub/zEnaGZDzs3RGvRvN2VVm+wAWEyWRgdC1Yb2Ulx32i0yuamO2KDZw8tWI2cp1UlQaJ
         c13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795124842; x=1795729642;
        h=content-type:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7EofMK/Ds2aCpVQ+mBzdmSBmTPWhoy8WE97V8cVUk4=;
        b=wIBZ5XSWZ23R890lubXijR0fcEcYZntNz7gWHp96akTYi5uz3IVcXwrEZNhX8G6S86
         gKK1yJQZ1KVhr3dhZJSZHiN6lGfUuH/oFPNA2rXuu0BuC6eeOaXVeFvOQuA/nCYLXXNf
         o9TskCXS4H0Lk1ax1HyXdHBA6z/s/C63INM1gSacrxIH6qYa8DE5uYYv8AhzL5VjGFjJ
         mf3Z69tsGxfM14jQh+rC3tj0HCK/8/tdoOA4cqL5YTmsMsw3bxfqyvlLET7i3flanrJN
         CMb7Rw2qadhfqNT8dp6C7UbrvwKC9eTcEBaHD1cns2aXjlN5iWDAZnL+1QQ80sLswj1N
         lXaQ==
X-Forwarded-Encrypted: i=1; AL+hErEHUMFHz9nad+AtwHI5LOcRUjCmggKVyTxkI7u18i5eTlcCNcwgSO76EyBpN+i5c26QfuWo7SFmpw==@kvack.org
X-Gm-Message-State: APuU4Z/s6wr3IR+B0foaDJGrsI9NK7W0U+BGMBPjhudlWedgw6c0dQkS
	D9cJBoZPNG/b+kwJ56QMC6UMGr07bB7zcieESdtlPiKYLaVsRdxHADMGatJQcDpgMHNCjM5vz8S
	t9NK40Boe09judlVYCPmBvk0P9DEXeEm2Hz0c50fW
X-Gm-Gg: AZFdTZcPZ87uaTdDeJGV+j3Eskc9kAF06LkgGjHUNk4TrLbSjDPykd9VuGgsnf1svL1
	bV1UNLNfuJdQthUCVZNzLZMhrs5KZMOCuL/bgwkufTD5UuS8jnaH2XiVARcGhVdDJVT4ziMUg9Z
	oPZ4W7W+G+0jAxpOmtbwpyoUJ8VrUxX7DT+nhQfG4m23MAGIlHOxg/IswEaMsWSdNhKqmeVSXVV
	GWVbmLpMMmXfJIKaaMEQWspnRcOtN+dbstyq34b9EQTm4oblDBzNl5KB9g+lUp2Ht9lcnk2kXuW
	SJFRPebJjOqC5J+L0MyIFFxbmHf0uWDyQYNy3gpeNo+U4J8YsKfVWxIrPzZl/5qkRgLK8szYO3N
	OxdNEfuxUMFTsfQ/CPdAsYbqCHgI7uYLE62ZeEsEpGEJOLPA+EPzUICzahQVxy6narZGmk1mT68
	XhvjtvprB1y8gp8QWQwM2r7Rc=
X-Received: by 2002:a05:6214:460b:b0:921:3585:de48 with SMTP id
 6a1803df08f44-9213585e1c5mr10964386d6.40.1795124841760; Thu, 19 Nov 2026
 13:47:21 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 19 Nov 2026 13:47:20 -0800
From: Ackerley Tng <ackerleytng@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 13:47:20 -0800
X-Gm-Features: Aa3M54rWsn9wxe2P3t1_p7RxahQjwFGHSbiMXqoPeTbRFHx6sSpgmtl4W0fkKbs
Message-ID: <CAEvNRgHpOQsF1E78uMs8OejSnNxWdRg-1_b-V56Z=kmotJt6fQ@mail.gmail.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-12-10
 (2026-11-26 cancelled)
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 778F214000E
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 7y99tpekmgsd5up6x6uqa8ndn9h71hdg
X-HE-Tag: 1795124843-859299
X-HE-Meta: U2FsdGVkX1+DOtvfnWjHN17pZ+EJ81uXnRhblzGraeyYYR3XnJehhW9M0IXq0nFDwLcZJmQBJ3g7vWpJgplGcyNArVwRGrWWzaTKPB7ZPXTJcTaagU3je7BhfBPR9QgRKGYeOvH1xMc37tKlePH6mJb8dKn1BclxC1d2Hvs1e4mdmaCTNBnHvozKe0JH2qJpObFzwIwOy5J99aNeTioM46o2HIoxSHqsgEx6fYSlojbuZzOsv/NRRXQ3MNcdtMuv+sJRul1D4ITZv/FJkeEg10nD82tbu1qG3wFTosY5q5KRBrH2EqniMYRzlGyM9SIyjijDT9cDaL+5hM59GpfOYi02JJM6jBD46NoY+WvYKUfFTuh9Rova6GyTZrsj/sLwqWtjBW8xbDPYPCiJzbpBAk6QPngnyU2dzMKw0rFxNStuOC7IcPsH5gor/3GvUESCFAYCSaUkOZFkwSR55+4+CxAjVkCNX0f8nzEI9TRrbGzqD9nTWS1GTo/579cftXrrh4HcR66nf4mKUk2WSuciADyzaU/X1XS03M6xoS+uepZRpCSEbAeab/mil7tMiKvHaUC+fWjOibUvsnOcQdPMWDEe1GNej0v37GrF2PwMoY7SZMTf2xKsQh/o9+h985z35jULXB4hNlhafTEzYroYUpJmPGjWR1ceVfroD/d2SULJ6VgteXGh7HvTwtSb+AnEt49BSudovm5b7N+qCUrK77vpV2UtZyO+QvMBwAE8UBanxs6aYwYk2GoxDWtJrpBnZJzI1ye2AnN3Fzx2/AB/9fEmrk1FtpDM8SN0eaYlUUiuP2922QwacRGiHhAGImi7HIIZd7J/lH+Lyhssv4QCouzlX4w5h7sqgT1zHpv1udYALAt0S/B9E9wiFqpCSzqd7woJ6G7LFIvOsJPlTAG3XENWEZANomXAHMykiIRUcmNvFhpuItii8Gr7UkP4of+v5DUfcIt3MIkIAj8Tx48
 0clMsqdW
 gbTBH7XewdTQWaxVRtBzohMezVwM6wruCQSX+m4MSJ9DPl7HOPf4oJYa4vEoySKEwp8021wkwrCYltRQf5dio1Iv8Kut2oXOJ/O7rC5EPvbd/2rOYqoXNMQHjoFpTWBKG/QqBWY9K1TN31h1XvqChdb8GK2ntOo1M3ZKo78y6uH2B02crw9gxt4/v+EQ8GtBZJ0L9h+Cqw+HhVtNCKvlmFosqU9uIcOAuF9Bq9yNnqiFYDvZYZ6Ol/aa0kn2UyqOiNeqw/d97pjEf6jdqKUr+K72XteYHm8HTcJb1jCLpj5+xd8WTWW7u2XjmhbHmyGZxWEO9XFI4Ll0rJWraDYU11heKF78ZJ+Ts3+zAZUAWezzyTnALzcLS5Qu8qnP/+Y8JuYDVTvmhvyLoUPE2Jx02D5tNlG8hhrs4UysHeqPvXNnEZ45brWV3HgvET5KzhHkn62rIrzObd2XIGFkNJFCPCxJy/QHCLy7AHUqdEpv0i1GyeCBcPOJt4urq6VM+2ae+Z09Q0Q5f3RFDzsFa3NENrCBu9JGhSozKjUqeuZQAzAu1gyEgpAWUKQDfF5fJncSUEdHOpd044h5tBZIP2VUbTBksnFvjT7d0l7Ax4VfXKA65VY3onFHjWcMRlzNvCoo9x7zgXOac5mIC7xyIRxa2b81+YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Next Thursday's guest_memfd upstream call (2026-11-26) will be cancelled
due to US Thanksgiving.

Our following guest_memfd upstream call on Thursday, 2026-12-10 will be
shifted 2 hours earlier than the usual slot, to:

 - 6:00 - 7:00 AM PST (Portland, GMT-08:00)
 - 3:00 - 4:00 PM CET (Munich, GMT+01:00)
 - 10:00 - 11:00 PM CST (China, GMT+08:00)

On our agenda for 2026-12-10:

 - TDX huge pages (Yan Zhao from Intel)

P.S. I've also adjusted the time zone for the meeting to be
America/Los_angeles so it's always 8 am in Portland. (It's what David
used to do for daylight savings too. He's nice to US folks :))


We'll be using the following Google Meet:
https://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want a Google
calendar invitation that also covers all future meetings, just write me
or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

Thanks,

Ackerley

