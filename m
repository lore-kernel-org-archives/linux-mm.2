Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC752606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 23:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h9KWlgAT
Received: by kanga.kvack.org (Postfix)
	id BF61E6B00EF; Wed, 28 Oct 2026 19:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6856B05B1; Wed, 28 Oct 2026 19:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A963A6B05B2; Wed, 28 Oct 2026 19:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7435C6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:53:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F223AA7BD3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:53:35 +0000 (UTC)
X-FDA: 85373689590.22.DAFB7CF
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1E10380004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:53:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h9KWlgAT;
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793231614;
	b=1xypQkmAB9d6YoVhkZdCDPZvbwwDuPC34tM7n838HVcqEQWbj7qU/TKYwy6jcVNNZQ4cEJ
	8c9Ik7XN0wQw+jeQtgkkhIJqbKo2klfLrDjJixbZi1TsuImPr7bZ6krGLK6Iy8P9Di0J0S
	LAaV3KoyMP9v+VbpBAOoOf0GnARIKOw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h9KWlgAT;
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793231614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Xf3WpLpXOd9QYLR4dzKoF2rSwhCdMC+MRZJA9cEo7i0=;
	b=DM00+lobDiHiAdnYMHywO35A7mNfqClf+m+dSX61C/nXnLVbxk8jxK5WTi5I8OTNIKYnqK
	VuMbJixH+QyWL0HgD8j9ZvdMYDvkTS/ocQTFkpA/b7HkGb4Jdk65Q1QckDOtTixqQfGNZm
	ldB99D8uDkMcfeIpDvmqkgNnkIDDuIs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53397554beaso19856661cf.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793231613; cv=none;
        d=google.com; s=arc-20260327;
        b=UaP07a/UZxWno2H/ptcExfRbJSV1FJGdantn3KSjEe16z+bYR/HO4SAm8yVLhG5DHJ
         5ITtwagZuEVqx8OqvUQ9OA9XeO/75O0vOrS2FLDh0hqHIeXSSkyQgwlsogzzpDfUh9px
         Z8WE4b1rfoGajZzV6VLlzxdiVVavzi5PqXfhn3LRFYwSdthW4IMzCWX+lJLzDr/YimVu
         VZ+JKdInDBmXuMmztrdxP+1QGQ36XOkVcj3QQWFugqwkKO/uMWLpbjjEaF7C0NCuYVfG
         XywZZj9DTrjQzvUa5MljDaB1XoXZbjq5lM4iFDIeOoCokFRyhs5Yn6CLgvm8Vrc9/zfm
         0Y4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=Xf3WpLpXOd9QYLR4dzKoF2rSwhCdMC+MRZJA9cEo7i0=;
        fh=Cm4ZkqnSi8yVWxoxZmBtyX2ffGc83ECzj1fILTzh3OE=;
        b=AvEAIdUcxeT3LLgWpaeNQjb1113qSut0RiJvjED3hsufcE9gZbSB7XeytdST7jsYkz
         XVCRCOPx0TXPThW6z0zHRLc73u3pHFTsnB+OMhRNh1QlpPxszZzVNew7fWfAX6w8IJh+
         BpyZL0/9dJESARpKTWq3L4qAyHK2fSSFLLuvn4o6EAGO6lFZOpUX7Abt2sdSEfCcmZZI
         ZMJhZP/uU1WHlt86wGLp0X1fscTwuYhRjAODLrehkN3nHSf5WB+YhLKreQ6sbWrdATQM
         YBWpEeRRKi7qQWRrucsZ02XT0ZA1YUVGmnwPpOoi1uuu1vwJ8+hS3iBJJqjTaWDpkmag
         9LPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793231613; x=1793836413; darn=kvack.org;
        h=content-type:to:subject:message-id:date:mime-version:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Xf3WpLpXOd9QYLR4dzKoF2rSwhCdMC+MRZJA9cEo7i0=;
        b=h9KWlgATF8095rzeiLUcyPcFFGUozU2sGzV8okEiZpuCJgbY6hHtYDToEsuSBtHBq+
         ZkA2hT4Geh1+FrXvdO4EaC1uwPEJB2QmkiqN+aITUyrHnOLVJ98OylUPDbaEtsntL2l/
         B8wwqHOKnqMUsxi5I81eQS7RbRTNzktOUOH94rvGe6eG6XT/UDYKsUl3XMxweXnvFXlw
         QYfvp/9ckHYb83Q3DVpsjYfyjflX6MdWLf+W6uMREUOgOht5bDsuA0AxwEu5yj9QE3n2
         Teh8R3FyB3VQpMcDPke8nbKTzZgh+kgKI1YsMFm4C5+nXuKErOnz9hnXyRD34KBjnvfz
         1kWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793231613; x=1793836413;
        h=content-type:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xf3WpLpXOd9QYLR4dzKoF2rSwhCdMC+MRZJA9cEo7i0=;
        b=oK/onEjB36NmGLQK4vqy29yfGTXGAiaybuzRd4X4APyGPh0XzDELDnYZa8J8EwjE0W
         +mWhdxQu1an4SY/5UzXpG1N1Hbb4xSyw6XWSxEgEfPbwUHDLFeFl0I+PbAQ0iG1fpAAa
         RbYFU1CH6uZK0JVeE9xqNOuRDLpLdJ4c5Uo5D6JkwONlqntRkQBN5ZfrK1SpRV4Vb9VT
         mbaLZTXZ7cThJQ3RE/C39YTmg6k7Qm3h7fG8tXcPDnOQziAVESOm2L8bWm3QlguK0xUw
         aVEJpJLPxL0b2bwknCjCYjChZ10Zw+yTiO3jedcrH9Xq0RzCL75sJLb32jQwJEImafdf
         DhCw==
X-Forwarded-Encrypted: i=1; AKwUvBwO//LbNv4Cx8vMFcm491kwSw/hfQDEsvvYK3Q143XBvVrUkJZQX3MvpvSw1qcf6ZZ1vFsCsDdI1w==@kvack.org
X-Gm-Message-State: AFq9FYJ4Fpc31BYrdzQxywysV8Q61SwtxMhILQ9aS5sw9lJ1sV6YOVWr
	W1IqTc9Hgv47NNHr9MO6fcdK5vG8pNmH1hx7nR9cUCIjgoVLzN7H7p5ckH4QqKm9/f+I7Y+khvH
	HrP6Ao6Z70+azrzMPhRtSzSnm/wT2Wp2nd4CTz8Ck
X-Gm-Gg: AYBFou3j3sxHqSjzBTNd4XFfAeqbYFsifIWJw9s8Oi/4tifbKd3bOGa5nsw3/5sWtAl
	3ukVeie2g3tAR902Es5bpW7pF+D7AH5Vim8WTeqUXMOssG9yDF2caW0mCKbNPnz0YqYAYPpikwX
	yVhc2NvVXu6SE9nFPmSXBjTXIXGeXNtZaqmQ6CBMlT4v5R5i76Q5uzoDnyRTKFOQexMjK9qDXbD
	W7IRMvAis7s+uEWDZ/snObnCfT8v+FB+OqmfGiGDOTYK0KDH2jM1W5rVUiCD7e5QKgNjiz/zffW
	fB2mkQAfIdotBU25AAflM+Abmv1ovGBnDh47T7FyKwXID/r4k/9guJDi7+WPPIhIAoyn3dqx4hv
	+/ldSqM8BDlhszYDHlrBJn5arP1oy7BZ84Qsrwv6++Y1b8OXBxaMEJahvM4PozYvEwGY5XWlXet
	wokIQwigcnNId8MzfuBln5BnA=
X-Received: by 2002:ac8:5dd3:0:b0:536:6856:f590 with SMTP id
 d75a77b69052e-53fcb5099a7mr71999251cf.18.1793231612338; Wed, 28 Oct 2026
 16:53:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Oct 2026 16:53:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 16:53:31 -0700
X-Gm-Features: AclHuK8fEnLx-zmlQH6Ok-lGIPb5dW6dcApY-4tFErjZ48FFcbY1Het0S7rgZRo
Message-ID: <CAEvNRgFaNnCHKe+rbGkw-BwCMoHzqw1ekUiMcT=zCh1TknzMvw@mail.gmail.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-10-29
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E10380004
X-Stat-Signature: aza3x3b9zqbz5s84sc9ksiakykicrhd3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793231613-207781
X-HE-Meta: U2FsdGVkX1+fMd1+D0bt0qatCzVVUyGWvZxGB01FWdIX/s6wcRnuE2P/+mveVn4y6Z8pJ5Oqmd8p50jrVMNllf7PHU10LAb6w3woy9UWyjoZ7OjrPas4aOT5Xva85Y95p1+6toOowZ9n7AHVLAhhNmCEK9KOsRrMfNH4aSSetZrieY/267TIHRNnPCwZIWtUHZrHwfH4mlSOS93MQY0zLRx+pHuWm2ONRZp2Hrg3MTdlRznBj8EVs1/sFNiRjG4jeYZ+qUutPYwPGpiiWcp8eJvjRmvu0VlSSs5BB72OT2Piax8YhL101+psBzCIpDBk4cew/ky7SfMuYFyzLHAWj808escGADWw09IhwmQEyZafQBflHKfwhlEfQtlP6C5gO5vh8Wd4xXSTkvFn5EnqcMSKO+/Lb8abTFzQ0IkJY2/k7LniLGCL0kGlFqoNHuzVKVCybBM7D0OnWwj/R/skhax8kx1d/4jdqsHJXpvTKU3NbNXoz2WqnuxWYQTEPmr88e8I0nNAUlfvHsz4kHYAqYLdCJcYXJ3tJwVaUj+FMUNOAmE76DBJRuqdGHRGihWtKMlAmpyYq2ceZcLjPQC4XIxjt5xPKkIEvXTqP59amVOm5jBEKCGX8rp9TWV5Jhsusybj0lQGd1W2jCHUuN59tihuAN+fBuHvyonr8sY90vevVKhKnbgNJ8fIBi9yIK+e3FXYJesClq6ebSXp3RDesYdLzE8mcUJ0g2I4IK8O5HggXfxD1aZovDv1kpe5jlUhEYaBgQU0yfvUcbFyqRYKGFf7fJK1bW+0aeV0rX+pRf+VDpr9YET3JrBsAGyguRlueaHLO57M6K3bLP6cwQFgc/lSafEHV7tW5qA0aCgtpUMxPtvDWhIkpAfZfytrw9cLCrJoAcXu9+ITW+rUO50OFo1Tf4IdVN6Bs+YMtpYsEYD/q1mu6s9Tp9uQiqpVSPDo5OPf6Bzc6yK82HDixvE
 8h/WFs9q
 EqtuEZxqpTgyiDS0SFIxViwAvDXh0y3iKPyoMlyOGVe8yVDW5bhRmTaVklEZdoUsQEwBJhfXmp2DAsTbRs65HiuCe2TJQH6QdcoZrUaNJl93uWV+UQlmdAW3YzcUOnxSVIvP3OBYbdtjX7PyBWub/R8kkjDtLEg8ZmjL29vMSbc9HBACIHPmg9Q64m4uZnI/OWwDccNM7yR+blJHoFGGmkYAKndvnQYljKlSrZboUQvD9GoTE6HpPgKNG3UCD3lzAqmSTsJEL87lmBBt2bJR1lEmx3GfBb0mwOMEJz+mQ1dWxfrw1lNMzETovCO4ubli27hU82FlxUe3T1znQXKMFsew6PgH6YzNL10frh7z5G07ZHGIaNn02IQnIHOOfWdniv+XMvwLt8tUAAVb9GBHlLUtk4KdB9h0+4LgrmnG3020nDGBNlVQlUmNfuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-10-29 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We have a couple of things to discuss on our agenda:

 - Alternative memory providers for guest_memfd
 - Quick update on conversions

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

Thanks,

Ackerley

