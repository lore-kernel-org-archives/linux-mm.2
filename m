Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0BF606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QQitm8a4
Received: by kanga.kvack.org (Postfix)
	id 605136B05B0; Fri,  6 Nov 2026 10:52:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC7E6B05B2; Fri,  6 Nov 2026 10:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDC66B05B8; Fri,  6 Nov 2026 10:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E77E6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:52:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80BCFC0DBB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:52:38 +0000 (UTC)
X-FDA: 85405136796.09.827E2ED
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8EFBAA0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:52:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QQitm8a4;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793980356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=imxiLTdOX5HC1rp3c25qmGQ65Qq/V6SkfQFDiRpdc+U=;
	b=5HIyCfFFHYovr+5NHdfagxtAGzBGdwXA/yRPTeRhT5HyCvZAwJXRvzz4l5YB2/ljltGBNq
	q8wrOqggBxVKkgm7ocGkm1dEs3VZurqaFb1wh2WW/9aG5h4JnBvP/JPBrRIVgrC87Dji34
	KnvQfJdx0YO8uJJSU2lRGEysWarWiMo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793980356;
	b=twjhuUd3kpMiOKZgy6uV5FXN1YS2P/DK+O5DDByi3PudxcAURqjWXmGRkY3XDUwkQLfKI3
	bhTsD9PYB5fOdb7poilw5QVzWpieHU6jOPrTo4H6J7bTab2nbzIsPdh7E9PIuToDdGzJU6
	TW883RXGhAejU8po7lrwMB7RjDSIPbE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QQitm8a4;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c414e5d282eso106225966b.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 07:52:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793980355; cv=none;
        d=google.com; s=arc-20260327;
        b=eHW0KQI0/YcmVEwwbTXK4CLX4Ce4DPCFiDfYt3RYJzJPhnh1yUQaQD3XDpSNIHAEVE
         CMjbpTgnUYxsC0kg4w3tOCJOvv2KF72Qzcg6sCwVGZcGM7OlM1EakaFJwxRJDxgATvcc
         hFHzq1XE2KTX/8B6o1slBirMBy6dHvGF9yuD5Lb7SVAFeWXKahTbJKDxtog1j+hAUhmY
         qgJEZBaJwLRqJKxdtQKhdNUPmBlQihm8cGATBBwVws8ed1I4EIi/k8BkeYYbHJX+2CBR
         Ri7gUhY563mxGh90DNBsIzrQ2vLEu76jZCdZ8hDIg1BjiLCttbDTUyuJvRxfjgnKLJ2B
         sCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=imxiLTdOX5HC1rp3c25qmGQ65Qq/V6SkfQFDiRpdc+U=;
        fh=E1yZadVcqoIIzX876JiiXpeoOsHj7T4Rpupk9WSN5tc=;
        b=RgccHRu4lqEiKpqC41Urp03kliH9r+4GSAnn/UkYJ8ruyn/CAFFuUxmVk+A8wiK5Ck
         2euZ8MsffWZRrp5ARiTTAz7tYl69+iNBEU1t83mD5WPjNptumTNtYtimgJKhmoH4pIDg
         pmh/X1EZ36NZRgedVnAuWd14irajsTzgXoIKw9jL6Vi/hKKG/j4rfBHEtoY3whX5Jmtv
         CMlmxjM+Rt8rC57XY+FD2kE4gzB1Ubw5GajOIciNMXYOl4JLbAgfhmO07W32RTK6ROG5
         i9+sltFVbW+kf80v8lIBX6xdCVg0zPK8j7ki5qDcTQDHw+BZeAhf/alQlCVAOSK2mp94
         tu+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793980355; x=1794585155; darn=kvack.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=imxiLTdOX5HC1rp3c25qmGQ65Qq/V6SkfQFDiRpdc+U=;
        b=QQitm8a4EiEeH08n4QWN6LR54/BM10EbRoLjzmWnm1c/hyiKdmAipxXvoSRKgFqK1m
         hRl2XFBPajp9JbjDn02UPX3Lvn5RZH/UUeH8JaYITtzdpz2uEDQXjkw11P6MncPek73k
         Ktx2iuTRBwqjkuJXGtZfaQWWtJNU76lEici26d/4M4q9Okapn7dw7ON8HfIUylNKTOe6
         nv9oZP9+1z95Z8pZ61XV9AIjnc951FRGLiQH47reTz4evUrKSYj0V+IR8UjCe7aNwWRU
         vqJMnw9KmiuN355+SyX3bB6g2WwAIfNE2UPNVjjfuq4wD2+deEx/78FetjjKHJ1AzMZ1
         W/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793980355; x=1794585155;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=imxiLTdOX5HC1rp3c25qmGQ65Qq/V6SkfQFDiRpdc+U=;
        b=DVrVXaFK18FIR4rFcTWm4HN1qaqKXlVumMXvf0T4ewskmGynvjloMCkuLuzY0o3Nxv
         KMRDAG1qsfsI4orSBE/+1nrwPRSI67cdHJ6eCsYRysxKToJjRdNA4MzIE9XBxDfU/piC
         LUJ24Yp0UDnQusghXlhlRs44wu0vW0MlZx0i/CjCFWldyPwN4mKqPJrANA1kQXh9sD+O
         jAGA8IgI5AK/FQzQ8Ul6H2Fq04XGIK+dkH323DXvcAfABwo9GvACY6fGFxGjzfLpNtPk
         fUou3TRzDa5D0ut2AGcKvIoaybQQHTVR0vMNk0UNdnZnwMxIPksY2XvJOtJZun1Teg6y
         Gb3g==
X-Gm-Message-State: APuU4Z+oWfQI+9L7C4bHPe3S6owqfvsOoJyFsILZmLsfHC8tee6S8dl7
	ymY2xF3DtXbJXnOfIGS2RUTo9YrCaAP803JzXwVVewBYSlWMQtW6t+mV/rpN8nmid6EhmhjRmLs
	7R+ieTYKP9V0X2k9qjRJmKLktoQUO4UaCQHYQ7dk=
X-Gm-Gg: AYBFou2tA/ccDsFOMNB7Jt0XSxN5/CGNA2tLl3TRSlxACA4UnlEHtTgbuE9XkfxLbb9
	AqCOjrGo38bemptr1hbLxrSg1zZqDgCYiF0esK13CnnRakpi2+wP9ZzkDQba734Z6zCcNFBQ6M/
	TsD6Ev38GUdOGNquaVyAvScUY/ZlB2YB7RI7YBcmO/AplMU3ZdbcLI3KbbcHASoPaiyy6pHihcp
	3eYASswGS6NaMNKhk/6fLOdRQhz438BxCCBtWnLcq6oNq5OYQe73f99egzFFkfWiVlhNy3J3c/T
	l6fk+O76PxYN7s8NuBBdQUjpk1mLRRIHJCNjAXgSwh10bUM0cOSUPxeupDHqo2DVDXhWXy9jafx
	tYhIxxql2Cbfd+qmNVcL94egH73XXs2widNWeTbiUu2nFL4ps1mhdPVkFDDh8iQry7UxHfo/BCs
	yhiVwqkjV+A+aXwAQS/AKGpNzDvR5k
X-Received: by 2002:a17:907:1c91:b0:c48:ddac:7eb1 with SMTP id
 a640c23a62f3a-c4d34cdc549mr257468666b.45.1793980354757; Fri, 06 Nov 2026
 07:52:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 6 Nov 2026 16:52:22 +0100
X-Gm-Features: AclHuK8p0HBDrOmkB3xF0AiTXt-CjeYHVOqupnZd0JdVBSmHKu9mDQ6Xg5ihE28
Message-ID: <CAGudoHGEfHXydqneyo94zEWfFZY32AWCOfQL01dYGCQKi0zJgg@mail.gmail.com>
Subject: unstable performance during continuous memory reclamation
To: linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gtgj7cs6q8jf17kpq8u4gtzj6nbj8sai
X-Rspamd-Queue-Id: 8EFBAA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793980356-73775
X-HE-Meta: U2FsdGVkX1+RA/X6/Akapvbu20/w7GCkE2HzYmAcBp1QBVTdNj2nbarj+rxFrTHtGfCwydRzZ8U8BcxjyYyt2bEqkCiFklTipla2fKR/ivcYMXBOTjZoA+2izTDoZ9RUYNM3bGXCY3Pv59EmSeyne/0NXvqo2OKyqADzLLC/Iurb+H7P4uYPnKZ5YsrtLrCKOipfTpM42y87khkQN4GL5n/IaKI0LSeYw7SMrqwS4b6QmqDoOX3AiUU6NCvJZAr62MHw7aO/RrBkLDA9DaDyjITYJnUp3wTYKoH2kqRyF/GkyX1cOKMmhTvUecag5Asxeh5I22bCSDI8vta8iq4iY9HRrGZ1f3de8vcQK8jQCUecsjF0fJg6xmVS+Ipkq0nFusdCPaCFLGcuNfKRBJ1NOYR8kz4UlJ4meN6hLbwl/FFvYUu/9te+OMQbhK3oGESTZqSR+p0UYP3iM/nOolOFjGWziGd9So1OYkxnWok0WDaVN1SNHllH9ZURUEIOx8IBpSecRFGEIfTSf+hCeaI7oJlSk36HntGCGsovQwV+afuF2ZwoumaZAL37VK7U6hGbIHyGGNHV9y9CTl97LgqQ+76PIxiGCpflwM5JKFo3yPBNa0CE8sbN+L5hCEfhXc456j26IjEvigDBtQNFCw9SwhHsWUVqSfnmTqyJH6QZhLI1yw+jDnJNtO+vCeaZcsm2GZr0jLyRLgzj9xuFwfeJZjDxlmpiQGBgNhvZ3aAVrUVpZW2im2N75nOH5W72J7uQbNPZk8NmCO40JsVrsluyptvWmSgH0gK/GVoc+iMmbkucfha5AGZRzllgo9zQtTKwbZyqE25s4IPdBV1PRFMk7LEtT5lJnDnVTiClbVgEUx6BYK+kLPkqQZOd/9+kxVqWNPtDAZjQT3amZ2w+UBEfs8e4uyGCErNvTBPbkOFKmFRkkgAXdYEDWzXgCLupvuLT9OUSvRuTuUeKz6E2Vck
 OQUmCICL
 7oGqB+MmjvU8sA/Mt5pKCEg9R61/KJ8+L8bEUU5Kj4q2ikPiPn74Eb9c5/rowFqhkoH2wqYnt7SnduWH6Z+eZwyoHC2t+jE0ZYyC5N9cggylQ8knN1egwUe2rI/MqRxNE/L/thv4+ucGulBJjgNXq2VQWCWIhYTIHHkoVUGKoSBZfRhF0d3O2ZtSSNk+ukGuIS34U/tPb5M3Z5AcAVnlW6IiL6ufaua8n5kfgn+i63FK0pRalhGZAl7SiujqwPCWnG+aid8C0A4Uhyb8VhRxkzPChuBxmn1C7ZKo+3VY0PUBnDnJiZ6RwLroG8YFAhg10aENFrdVuqwbEEeOFP/g66gYY11JzlxxujvxSA67R61jDcwXVz62Nj+tvOXHmkx9SS6Qlt3AnJgwVF9ctpCdsr40lIwHYKQmDAtoo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I have a synthetic benchmark which stats millions of files in parallel
(each worker stats inodes in its own tree), which I'm running in a
loop. The total number of inodes is purposefully chosen to NOT fit in
ram and require continuous memory reclamation to proceed.

I would expect the total time needed to be roughly the same for each
run. Instead I am seeing massive variance, from 18-ish seconds to over
50 (see sample runs at the end of the e-mail).

I don't have time to dig into this, I am posting this in case someone
would be interested.

You can grab the bench here:
https://people.freebsd.org/~mjg/fstree.tgz

My test jig has 24 cores and 24GB RAM running this against ext4, the
kernel is 7.4-rc1. The problem is not new but I could not be arsed to
write this up previously.

The fs is prepped with mkfs.ext4 -N 24000000 and mounted on /testfs.

$ sh createtrees /testfs 20 # creates 20 dirs with a million inodes each
$ while true; do time sh walktrees /testfs 20; done # bench

sh walktrees /testfs 20  3.32s user 255.90s system 1397% cpu 18.55s
(18.549) total
sh walktrees /testfs 20  3.65s user 376.84s system 883% cpu 43.08s
(43.079) total
sh walktrees /testfs 20  3.25s user 253.34s system 1314% cpu 19.53s
(19.527) total
sh walktrees /testfs 20  4.45s user 423.65s system 1079% cpu 39.66s
(39.664) total
sh walktrees /testfs 20  3.19s user 288.14s system 1590% cpu 18.32s
(18.317) total
sh walktrees /testfs 20  3.34s user 342.73s system 1124% cpu 30.78s
(30.778) total
sh walktrees /testfs 20  3.14s user 231.58s system 1374% cpu 17.08s
(17.080) total
sh walktrees /testfs 20  3.33s user 329.40s system 1108% cpu 30.02s
(30.019) total
sh walktrees /testfs 20  3.68s user 301.85s system 602% cpu 50.70s
(50.701) total
sh walktrees /testfs 20  3.61s user 259.41s system 1172% cpu 22.43s
(22.427) total
sh walktrees /testfs 20  4.20s user 376.32s system 1093% cpu 34.80s
(34.797) total
sh walktrees /testfs 20  3.50s user 268.13s system 1238% cpu 21.93s
(21.930) total
sh walktrees /testfs 20  4.17s user 377.34s system 1065% cpu 35.81s
(35.810) total
sh walktrees /testfs 20  2.81s user 245.95s system 503% cpu 49.37s
(49.373) total
sh walktrees /testfs 20  3.75s user 367.58s system 920% cpu 40.34s
(40.335) total
sh walktrees /testfs 20  3.73s user 298.43s system 1191% cpu 25.36s
(25.361) total

