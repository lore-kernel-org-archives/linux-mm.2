Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47ECD606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VfkkbBlt
Received: by kanga.kvack.org (Postfix)
	id 607726B05B1; Sun, 25 Oct 2026 06:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8426B05B2; Sun, 25 Oct 2026 06:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE2D6B05B3; Sun, 25 Oct 2026 06:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27A4F6B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:09:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 620451402D0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:09:39 +0000 (UTC)
X-FDA: 85360726878.06.2A9681A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 85042180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:09:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfkkbBlt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792922977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9QnU2pBsGjIFmv9Euw9yPy4UBXfMcM3EXn/p1BGvaw=;
	b=duAA0zBeroMrFXJ2JYSIz58V6SkbtuyVN5lDyda7FuL5OMIN8+n/ZQhD+09+M0HEXZtPvS
	UZl4lamQjcCNL59Z6L9LBfnz9mUS3jmNPVaNznaK5Pcihp8BCs2GooOBa1b67iNU/35ARC
	lU32Je2IWJVa2v4OThE+HXoht9Odtws=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfkkbBlt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792922977;
	b=47LdebYfL4mVJulb4BZRd2jFje08tyWJGtcvI9ge5gcMiLu8hwvEaOQ+IFRGhT1HZqAXMr
	ZJ78g/O1jz3YRJrSsLDhxFBriYWK+xdM5uM8ZRuMLjpmy6lRgQSpVNBjglBuvyX7XAatVO
	E0/8jkzSsGDJ9ZFITbgQ5sOL4KM96lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BED8C423D4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F0B1F031E5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792922976;
	bh=x9QnU2pBsGjIFmv9Euw9yPy4UBXfMcM3EXn/p1BGvaw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VfkkbBltC7bsCM+rryO+DA/DdspsX0PfPXpnFrniEqfAR0EmFYeVGINTVujq8fXon
	 9meZtkY8T5Kp/W52P+22vw7Wwhp+wsRyFuyWjmF8A31c2etBkSTZE5EpmdU5B654vA
	 sRjKNj4+4Jyuz+OLj4lEVKzwuZE6RxR5Ik395HfjrIY44KorpL2PKvjpyxRzAciL1y
	 IJS8Ldv9yyiYecnrNhVsTSWsL3KkXYdJ+r9aAphG44pFpYI0qoi/GNiBFzcyWJ3zR+
	 NhaoeDfPQ1knN3JHF8+4dMP7NXLFJl3YIaglTmUxLj+GqcJ85J6eaLA9IrwbdJnBT4
	 7RfD5/MuvqHLQ==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91b83459526so27381656d6.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:09:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy7CzQ4W3pogpJMcQTsjskeiD/Il+xYPrJWXNjXheHtfJlCz38Ctgor09z80kJs4O7xWVymiKOPUQ==@kvack.org
X-Gm-Message-State: AFq9FYLIMzIkbxdVgo9Am7o97DOHoBV1qOFjHERRBEEHAw5DpqSM90t4
	LkT1vNzPh+4CI9lEdcZgYekS4C7R25lS9hGf+yGrwKFr2tzzG1HAgIBIhTtCiGu70GwynvMaNvt
	QkLebYuF3Zp3k07FMQmVBLpF0bJnJJpk=
X-Received: by 2002:a05:620a:271d:b0:93e:c35b:2332 with SMTP id
 af79cd13be357-940ef9504b7mr498180685a.73.1792922975943; Sun, 25 Oct 2026
 03:09:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025021839.1542805-1-senozhatsky@chromium.org> <20261025021839.1542805-3-senozhatsky@chromium.org>
In-Reply-To: <20261025021839.1542805-3-senozhatsky@chromium.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 25 Oct 2026 18:09:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xxB1Dp-wFkw0bqF6hUtDERxmjZ9e0k01MYtaECvc2z1w@mail.gmail.com>
X-Gm-Features: AclHuK_hSR0uvsmfM9khVcfYjoKkHuYjN_xXHvZnCMI2yL_FlRUxprG3VMTY-6I
Message-ID: <CAGsJ_4xxB1Dp-wFkw0bqF6hUtDERxmjZ9e0k01MYtaECvc2z1w@mail.gmail.com>
Subject: Re: [PATCH v7 02/15] zram: remove debugfs entry on init failure
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, 
	Bo Zhang <zhangbo0325@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85042180002
X-Stat-Signature: kocw36fswrr3wdng9ka9ewup18j64wbn
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792922977-551805
X-HE-Meta: U2FsdGVkX1/864AEeu7MgfeVOGo7KvQKiWiNVMNo6cZpm+gaJX9iWh/UdvoIg0iQov/h61szZxAkVRtmiAb1pJKs3gJ0fK6JJEfKhbRGA2nyWFFxX6PtRkRV4shfk4u8QJwu7FiLFpNgXeqZ/aACBSzMUzHwXEDLYfdM2bEa4FslGqYplaurNzFJcDOum9vWlqyqz9xJpfeByDMogo5jXjEt3f6G3aGh9pjVhWBz2Yj5WtDYPnJlWrblqrzB2PxIZBUiXK3XTEXziEp3wF31d20jhqO3/v1caEWQ5JRcVRaCCP7w/3VuQ2djuMeNcj5pT1PkUnulVbgjXdJmevlLlRVfd29EavP3UxT3aZL+bWmLFsBw0le7C4KUm7HNqEJrWusYrKgg5DaYvM5iHoAuRSLWLSLWS4BVOwRzAJNS6Q9eTH4XyV2DfoNPKiASxdVZhX6sdRBszUey6F737a9Tggb15gUG5TQzdwPajy+HmZb5pJcRGRFszcUg0k08hRFmIIAp3zK8hVetl749FPgeTPk0HHU2vXdgjpE9KQa1I4D7uG5daRXKdH35jfrW/b7CV/TP3aCcaIFGP0qYjvmgBzL9Q8BrP/QfSc0+ce6j/aXopvnxDGz5lpOSyQy2zkHc/VasMLVtUh9Fnmn5ML854i6QbMWcD41EwNkMalhxxR/yvvcAdyziHxFJ89AgPBK9N06ynE9rD1Jjzm5ZXvJGLd1sndlqqMT5MKQRRQZkWkYIVrQBkezkIJbTYvTdNrubCqg8A6V6J1SKe9sn48t2jDQ9KYK1ezT7v2W6RS2mxv6r+9K2cftJTGLHJqzLL/8Sm4tEbugyzzHD7J1U+ogBuiptkjYVetRWBDbPdZrGhG0ComPXVWGTSqLz81ZF9cEI6sqXwmuC/JyJdIQS3f9YNMveCWiLRpnKTKkk6o1jt/W0cOk5+bbm0bO1Nk9BlxILTn+PgxJD/oyqzda0C6l
 TiCUs5rs
 qM3lzdJqsRgdg4FRHY85bNTSbpehmrfjX47tZ+5KzuiRstMSzDfSHJR0pH83GKKI6FK3f6DqQ8AlLPHY1cVETQGN9gzWYjkFAoZgdCIHzhzSlRPLPKhAu2zXc30YokHYKQDjAaEsd8JtiGJGNJxdyNeqCSMxKixK1bLybdS9nrtG5WIem+0XvaWxy/DQdOs6VGZ2aaCZaZJCn8Is3EAPI9DKXtD6FMbM4FvV+NVzd8UIHRWwZONE9+YcxHKwpY4yW8M+p99sin0Zsfy5FqlbKt+37f1gO6hczD9AjNsTjOU/EgqlSMSefSPBfYIrapxBKWhsDhsEBYCcRCaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:18=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Do not leak the debugfs entry when zram_init() fails to register
> the block device.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 1 +
>  1 file changed, 1 insertion(+)
>

Reviewed-by: Barry Song <baohua@kernel.org>

