Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F81C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 18:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF1B6B008C; Mon, 31 Aug 2026 14:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F066B0092; Mon, 31 Aug 2026 14:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157FC6B0095; Mon, 31 Aug 2026 14:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB8DA6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:24:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CCE0140180
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:24:31 +0000 (UTC)
X-FDA: 85162389942.09.38647C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1650118000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:24:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z4dkv04m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788200669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/O8U4/wbfjjJlI+bVE39fAH1Few86fKyT5XoAx2L54=;
	b=w3JG9abuz4Gd2DuvuCaqgmsqv4+ICgWagyzyloUg65Mvwx6AkpHMIHe+ndNgh2hDDAJiXH
	uymsgoVlBZAZDlyWfTbfm1VgNfoGkFfT8vsgabTuKxxDaoqXFLNTVDiznEJI0Im+mjStWF
	0Tl1i8eqBZg3pDKBfHESWk0pvwrfDx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788200669;
	b=8H2Vx3uRAbMYnC415DmP7rLaHBa4BpEn2QZe4imNARGIv/2yacr0q4ck6ZOfl579EHdybd
	FNYLZmyhmuiNwUuq/0GyR9ywu+TDG2qcxc9AdU3jjKUFhddzUMMlwETErF8HZb7M5luvlu
	mOdAB5uLmCGnzhgSQ9f2xVOBGx4j6zc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z4dkv04m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788200668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/O8U4/wbfjjJlI+bVE39fAH1Few86fKyT5XoAx2L54=;
	b=Z4dkv04mO6XpeDlAPe9yIwY32vDbie6oKTwlDqBy33wMZBWI9aUc11yNia27c0QhK4QFC3
	oHxTLW1qj2z44Bf5c6xzDEoTh//s+/nelQoTdRW1nGtkdyWbvy6JJFSFtqyYq5iEcH2Syn
	lXPv3FxdkvBZJ1k/JDYAdoP7l1qLqv8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-6LkvmBIlPU22cg6vsRZfyg-1; Mon,
 31 Aug 2026 14:24:21 -0400
X-MC-Unique: 6LkvmBIlPU22cg6vsRZfyg-1
X-Mimecast-MFC-AGG-ID: 6LkvmBIlPU22cg6vsRZfyg_1788200660
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F7A1195419A;
	Mon, 31 Aug 2026 18:24:19 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A08D618005AA;
	Mon, 31 Aug 2026 18:24:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 31 Aug 2026 20:24:19 +0200 (CEST)
Date: Mon, 31 Aug 2026 20:24:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <apXGzcA9BmrbrQZv@redhat.com>
References: <ao7Q8miiuLAPVnWv@v4bel>
 <ao7iQ_wOLghOvTsq@redhat.com>
 <875x0qclcx.ffs@fw13>
MIME-Version: 1.0
In-Reply-To: <875x0qclcx.ffs@fw13>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: O1jB9Z9i2w89dPttPZ_GogUY_HCzw8mB6Zm6DzwMAVU_1788200660
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1650118000E
X-Stat-Signature: o4shkz8t13ska488xxe1wz19pbewq4yz
X-Rspam-User: 
X-HE-Tag: 1788200668-757552
X-HE-Meta: U2FsdGVkX180Dr9ttFis6FM8hQPM8SaHXSRcagNq4N4TCYQH4KlvNRdrmJTnxdD2KmEkX1vAG4rwHG99ZMyPTS5g5oBRZFGR/hkZKo/8cd/PWr4umBPGe+XWEJbxboguZx12g/vEqW+R4vKP+bZrJQTHW6W27v8AcwvkbS7CuiAJB4WrNH9DabqDly8UKBHCabOtTJTy3fVIxD7szsZbKaHk3F10NiSLj0nj3ug1c3nHKXarn+ULSTeTHGxLoU5mxO1xk8r1mYMmQZHAIOiUvmLE2S9sM3gp8ee8TcoIELopnKRBYzbvSZaGLiFXq4TDcIezLvNVZfgOH8oBd/hZQw5VbWcGUOKcGYy9n2ulfXUj465oBT96YKAtnjNjG0oPNzeit7SshllMkReoexOi8/7aFfxS94Nrur4HYGCW2xFz1K8skdpNAQVFL9L0hreVUv1sosDQEi1Z++GAPbdM7kjiBlwk3+C8EwP5Chmbnpfn/AUJJoK58TPMiEKynmwBKdh3RcTjihqNrQYPH5GhZzyf9t7l7lRntJEJmL0JaTqKrsQtwhdQ11IgtmvOoqJlH7Q03Z4iLthsfNUA4ZRbwRZcXV2V/Y3I5+rUHx+TWetMTBA3YyK8mA6zTEjF73OSZbDTaZkqyiOzG9/aLG4CHWVzbrDc1lkEUPNmdDHfei9aCPPBGt8rNH3LqXf979xmLTfISV1VGp5kequub0fWREG7NCRd5OEc8zJwfWq6FKkYLDR462NAv7+rVHUETy6gv9bP7N2hwAIn+o9/qVMIJ4bFuwjAmI+e6mPa4A2OjyU9o2jZSg3XFLFMEng1PSj5BTmXFyEohH15tXTGrhyHR5BsF0gs8TOuMAXG1aALecHY8gGjLK4GHjLthFb38QODpQWuOUVv1BsSFMHpWxwT22JsVupsCQFjJa7TneR42CioYRS6A9T3vvBL0fqUfZACH3yQe9NcfwKGPdPRyw5
 RI+nKyOz
 GJyvAFaBwcu4p+H2uN65gpqGg9CwxD1xufRpPgw7y6Uj/Jtx6YBAiPS80KXZ4/AC917k2mkCUpRZyTzQKgGuWyePqScOoEeL4xpRZgfAbTP7I+MDzy6pG0lBLsUf8LyuRLZ9sggmDrf+PQUk+LepOqP2V9cjjOg0G54vYFohbNYwPZTF2fkl7LxKIg5yizRpNbB8B0HZ3zYOKeoG4MjQ0uCs1ubm/3q+hg3ugqljxVEM8Lf/dRkU6fc6zq6SM+NpQc4WDbqLs4fIMp3oTA27MvNH1bn+WBDr0EicJVKu5ivpgHdooN9nYKl7Rr52+Y34okEgzZnaEQr5QKdHDZ9BihyrUffrpxgc1bW99FDSfWUrd3UeIXBZ/fHwGqRxSWN2IRWABiV7Lmzymg+xH3QlZ0q4rlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/31, Thomas Gleixner wrote:
>
> On Wed, Aug 26 2026 at 14:55, Oleg Nesterov wrote:
> > Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
> > sequence in begin_new_exec() up, right after de_thread() before the
> > "if (retval)" check?
>
> Yes, but that does not buy us anything.

Hmm. I don't understand but this doesn't matter.

I didn't mean this makes sense, I just tried to understand the Hyunwoo's
fix, in particular the placement of additional posix_cpu_timers_exit().

Oleg.


