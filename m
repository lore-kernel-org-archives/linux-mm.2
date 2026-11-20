Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33BC606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BbGfJzNx
Received: by kanga.kvack.org (Postfix)
	id B08A86B05B0; Fri, 20 Nov 2026 09:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB97D6B05B3; Fri, 20 Nov 2026 09:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9066B05B4; Fri, 20 Nov 2026 09:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB9A6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:34:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E05FA40F39
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:34:11 +0000 (UTC)
X-FDA: 85455742302.08.5CC21DA
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1478616000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:34:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BbGfJzNx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of arpe1618@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=arpe1618@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795185250;
	b=HBsW3AMW6y9f+C3MTsHhRwrOizQwrsuGm+wZzFugdSorHi9TKkJJDnXrXftFKWUqoWaMJA
	Cm3dorAtwEDA/d4rivnkpwl2CVvu/aXQJxVfY0nrsuCd0zyaz7R4Wpmin/AWur5ngM8H4N
	m+ROEKYn2SJQRA7PCITA83fznG+Mc9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795185250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zhTAZY7oSFShyaCtYnSLEI3yUB00f/zfvDFBFlOS0o=;
	b=4PRH+zjxGwpHj4vUVO3/NkBBNXQZlQUufB+TGelwC7ZC3EVof2EQNd1MLN5wY5PsFSSfpl
	6XaKRIOg1UXaxSr2yMtsdIUaXNIsMooqry3weknYD4yztizo1wkIHuPn19bKqQmNf8OagR
	SHalFBuBH2NpsWm5aYd2mwG6lElCUVU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BbGfJzNx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of arpe1618@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=arpe1618@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ea19c28a50so144295ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185249; x=1795790049; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zhTAZY7oSFShyaCtYnSLEI3yUB00f/zfvDFBFlOS0o=;
        b=BbGfJzNxlaTF10/IheuHQMCqa0xoZYdIxy9KLic3Tcbhve3J8MyI3ErNuc296IUwGQ
         y4s4qK/hW4A99yn1ekJOxpCeR8XZZoKekFexj6IFyv225Y5lCRQ8tOL6e2QrP1aMEo4O
         VfO/PhKUNmP8BiBwlgYe+6pgf1PHGqE+qolWOzALJW+BObV/ZqOb6NJrJf0ou49fa2Xk
         kdTCWs4XXVz9GaV6j+Rn/Xza++RvRi9pOMMpdJGbt88FlSwyzYR8ovhscEy1c6YMP1en
         F5tVHGJx84qXTRHZ0wSs0Fx+SM9fQ5SbmkMvyza0TAfd8aKpDmOYqxTub7z4TCxA+tnJ
         aQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185249; x=1795790049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8zhTAZY7oSFShyaCtYnSLEI3yUB00f/zfvDFBFlOS0o=;
        b=jPuQOQ2jSoQUjKG1KYCaYSWmGn8mdScDrPVxvAIseuqkA++z0ZDzPrmqUjAJnD1nSp
         yA12w7ECQ+SO05Tbd1oF6eZPM8fV1Y6egq7i4chudFc1w0EOmEGuI0uHApAPoJJm1Apk
         DVlZLYml4BYhIXKKHX+0yEILf/ncJSCDV6MFIeGA5hhhiGnjqZFJFGlOlMtifOiJNiws
         X7tI2BOOovRC1QdwC65FwnGKveyE6qelcP3LgayZq4JCNTdXckyE4dAR1iGGFQX1pRKo
         kt0rjl8lqBkuaLod8wcc0IdIk8m+cfY/+7/fUJpqo5licTMdibFr3HSmEXbXCIlkNY2M
         bNgQ==
X-Forwarded-Encrypted: i=1; AL+hErEEoS85Sfag15p0bXgXtP5xlbNuDSZll2T0BfGcoF4IvDDe2LFi/HPi7Y129qL2MM9/hEOqX2xsJQ==@kvack.org
X-Gm-Message-State: APuU4Z/B7hGsapgodZcguGTOnkEdv5JdIAIs1vav23fwz1q0veQB7ZUY
	bY/vJ+kO8VkY9p3ICJrn5lufqo+uzWMdr8jJofSTFFFZGX37WJEbasYX
X-Gm-Gg: AZFdTZdD18WWtitZGZubjFejNi+5EakyZoT3E9zZJsI47zpeTStuda3rbqenyAYrvkl
	ik9907kDYMVVrd8D+vAIcEWeqseB6Tzw7O0XRkkk6bDAICwQJVlu22dCkmesl3jpsFezt4rByh2
	eOJ2+Z2Eq9gofz95nvSQt5qMlDEebH4luhqkxJzKUNUYcicdTDRzVVfQ0ublkFOTkbCpdMz5j2U
	97vAg+TlVO/UfR+XS9G3Cd0UQk5vKGMN3uSKdPLHHC8dVaGoC+dQ4UpdhJTEq8Ex/PMGG2K0zhW
	IhiIxb7UfXykAYjo5Sc53tS3DjwOtn+S2EgFy6djkT8n27/unbLMY529qULhHgmjGJXntNzFDXM
	sd4w2h8kgssOdzRLQIF6nPx0D/dHGymnrlsG83uQzUF+31G2TEBV1ncsIBQLGS9bFh8neH085Bm
	7YnJBDA7kcU70CorvxZXFiOXitZa4Rz508KNi3VcZm3JkhhoSvXmNLyRstZGXMA3Di6i9WkEVRE
	W3xSo+O8JQeYiMuL4aZx3X14L4mwi+H9JVyUUBhHKJonVYM4myvFDmHAH5DgLLaj0KOQrDckEbL
	kDl0bQTJN5IBg0R1bZDc7vOBPxPBEeMqLoqhvZEwSYIWtsIhxH8sJfhSP9CytRUco/nnMzHVVMf
	DPkic0IqWaxxjd9Ny9D3Mb3cygQ==
X-Received: by 2002:a17:902:eccf:b0:2e9:9263:a58 with SMTP id d9443c01a7336-2f03f0c2295mr57011025ad.1.1795185248619;
        Fri, 20 Nov 2026 06:34:08 -0800 (PST)
Received: from DESKTOP-CJ1L666.localdomain ([211.198.99.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f42sm15137815ad.25.2026.11.20.06.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:34:08 -0800 (PST)
From: Jiwoo Kim <arpe1618@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Jann Horn <jannh@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Chen Linxuan <me@black-desk.cn>,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] pidfd: use one helper for pid namespace visibility checks
Date: Fri, 20 Nov 2026 23:33:49 +0900
Message-ID: <20261120143349.979-1-arpe1618@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1478616000A
X-Stat-Signature: 8shn3jh8p5ib7kdwyf9fr8uzqidpws8j
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795185249-237985
X-HE-Meta: U2FsdGVkX1+SbWzxSBz6G77aOHVAge2YVz5WMbeGLC0fJ7XiMufH+dU/lny0OcoRJMw8WHwT0dXyE5p1CT5d77P8Wkk0Y8h1TKH1qlw0jLifdZEGfFMoqFU0FW2KPubTDZR3EfQ39/dEkxMUdJdbTucb+8MQpzBfaC0pLp54RFs+RVfdLm6ov8AKThJqxg9ePqtL5k2OBvv82YGLbyljaeru18Z3n6rd6Xg0mePgI2xQVR88PsUkUQoNq8WgCk0zCW/W4c6WmLGBYYFPXv37MYlSlYkasK4WJ54DHCv0VdC20tBNyXWMePFcCWJ+DLsXhNwB+sJbkHfs2VgLz5sDV6AgZj+IL0Km099CmZaU4k+vhuqOhjlwjkzFg3fdI12yK0K/lsfPTl9oGOHVja3bCJ0mFYHkix1vVpuvkuG+moumwgwtTmlY1YFG5jUber/e+tR3BW8Ch8HaUGv596Iitipcyg1v47U2csHU2PL/BaJ4Nv/g/aYR7w73Dl5VBW9eVZxfTPY+65n5FezQPJDFuPvqNQNZeGUh0r77CrwMe/EqfLoDldzOUBWq6nvSDoaYzKTrecAbHd8bDxHZ/imdV5Tgvu1U0KH0DBgLq0wk7W5sLxL4yIXUFoUXD+t6/bl7nS7GZY8Lpu8cEbezEoHg2cbpHFbEyjHp20mjCfqj+O6Kn4fEGYPso0JV9W/YPdYjbxnlaWGBNNrGZO9f0eZFjnZ/btTee9MSRCQndplbZA4VDv1eYPnH4mXdD/wrpiBOHa26RI6yOUxL2eBQ2GajbNah8qUD2qFkZsXcZ3amGL2RGanaUu0EFuU5hFVK4wNJBqHysUjVvWGZeZy0SaTWPkimje+hSGgk/znmz9EfZt6oYEiCZH4t/36F1ckyBy5anCBPpYMpq0wVkTvYnoaeZYU72HkNS3+Zmij1rzIk1ufob5pL8VRI46dus2/BrCib7p4hv7HMky/4ME7Ii4r
 RjNuLQbN
 XUuWqPPW7vwh/9mTiVbowC4uob9tURgTpL4RGMzevhO5aHSDbNyAvK+eZ7NJIBi+uih/nf0iJ64+dOIbknxfgmR98njo7AaSdWmx8Vi5zUB9SGGm8a23Zi22MFxdYY/Vlpr2wjgCAUBAWaV1PutSGKhtVI1kTgjdr/UY3gD89Ow2Fvkn1G04f4xNZab7vo2sGsBR3+sw4i8e8FC/TgbmD57sCVKM4T3PBo+kWZY3n7VOaO08svMsoXLCteZLLepDERj8QF3T7ctwMKGgim6QaPd2BUo5lM42z/geGnQvE0cIOPAFi3UArP1WYbZOQ/sVhh78lqVEKYXuGXb6Gflv1OsA2iEiKU02vsjorl+KGyJAcBVH9UH9zEzVbMzibpvj8CO50wdgo084urJa/9Z08m6uMbz34gfW1yumMkZF/1TVGRL/rwUZdtvfM9OiLYXJXsnXCASBAdEKUvCv6IyDJQfcrLgwkHHoyvhSn9bnVDksYUqn3czGfgdq59ZLvT2899vMw6cvvo+bQhq1PlWhNr+OJ5UDWPwZk34QNWjZ6o8Uw2jalAT38St9ivmFmvQjPH3t9Rb9V9h7RSHznH1wwHnQ9bP4sQPec8JSTEvcPrHm0bnfAdSRN62V0FtKnZv7NzrNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 02:42:08PM +0100, Christian Brauner wrote:
> The pidfd api checks in a bunch of places whether the target of a pidfd
> is visible in the caller's pid namespace. pidfs has
> pid_in_current_pidns() for PIDFD_GET_INFO and the namespace and task
> path ioctls. The pidfs file handle lookup open-codes pid_vnr() and
> pidfd_getfd() does the same since Jiwoo's fix [1]. pidfd_send_signal()
> walks the pid namespace hierarchy in its own access_pidfd_pidns().
> Yuck, unify it.

Thanks for picking up the fix and for the follow-up.

I went through the three patches. The equivalence argument in 2/3
holds: alloc_pid() fills pid->numbers[i].ns with the ancestor at level
i, so the ->parent walk in access_pidfd_pidns() can only meet the
caller's namespace at pid->numbers[active->level].

One nit on the 3/3 changelog: process_madvise() on another process
also needs CAP_SYS_NICE and only accepts the non-destructive hints, so
there the cross-namespace case already needs a privileged caller.
process_mrelease() is the one without a permission check.

I also ran the series in a QEMU guest, on a v7.4-rc3 based tree with
the fix applied, as uid 1000 without capabilities:

- caller in a child pid namespace, same user namespace, pidfd for a
  task outside of it: process_madvise(MADV_COLD) and process_mrelease()
  now fail with -EREMOTE (before: -EPERM and -EINVAL),
  pidfd_send_signal() still fails with -EINVAL and pidfd_getfd() with
  -EREMOTE;
- caller in the target's pid namespace: all four return what they
  returned before.

The review and the test were done with the help of an AI coding
assistant.

For the series:

Reviewed-by: Jiwoo Kim <arpe1618@gmail.com>
Tested-by: Jiwoo Kim <arpe1618@gmail.com>

