Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C36EC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CFC76B00A4; Tue,  3 Mar 2026 07:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7D36B00A5; Tue,  3 Mar 2026 07:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15806B00A8; Tue,  3 Mar 2026 07:32:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF9E56B00A4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:32:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAFCB4B9A3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:32:49 +0000 (UTC)
X-FDA: 84504690858.24.2CCD745
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 954281C000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:32:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBkJK2Z5;
	spf=pass (imf21.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772541167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAsbkvWEurEl7FG/bk0zWpeDiH+kFLfDNlmqSJEZ1OI=;
	b=UDpr5xo3odCgEgZGqp+Y0B3gdDUEum81LbRZwAigNaOsPCfziwPjSM1b6q6dQkCUMzB2k0
	Eg8IcGI8W29SAhdFBESlrreoVpHJ2b61rpGcx/iLwOkuLQpbwxvKAVqkLRlHF6Y77BF7AN
	cAEu2Lq5SMbgwS6Xr5oCiKbnvmmWwlc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OBkJK2Z5;
	spf=pass (imf21.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772541167; a=rsa-sha256;
	cv=none;
	b=1GnnFYQVB6/X5OQNLvwQHylpSpwolMIGtVC8Hwg4YT3bvCkLz8tAoEipFKiVqpNWQ4lTqD
	dduNVmwtsEY+o7TAHjNmt3xTTpKA7eY03HGkkNkHvZnbpOfu2k4VRSh/v9xuLh1xCR1L4b
	gg3Jh0CN+ceT4c/OkyRL+ZJJmW8lDqs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772541167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DAsbkvWEurEl7FG/bk0zWpeDiH+kFLfDNlmqSJEZ1OI=;
	b=OBkJK2Z5aLB1FAmR+xZWYOrgnHbOsDGMoTMdhKoxqFmdFDh5iheQJbaFFfNRdw8LebUIHr
	znwpreZQpS41LncgFr4Av9hNPNLM/09loygAPa5cVU1/nbivHjESgLg0jR09LOp3M5xNak
	2yQjUEO06ilL8d7vIK/qBNbM4vJGA3k=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-rFCqZE_9MjOTUpPxL5LMBw-1; Tue, 03 Mar 2026 07:32:43 -0500
X-MC-Unique: rFCqZE_9MjOTUpPxL5LMBw-1
X-Mimecast-MFC-AGG-ID: rFCqZE_9MjOTUpPxL5LMBw_1772541163
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7985951fa83so105415387b3.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 04:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772541163; x=1773145963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DAsbkvWEurEl7FG/bk0zWpeDiH+kFLfDNlmqSJEZ1OI=;
        b=VmxKi/3QGlSQMS5NX5CkCTtffNoAfAQPWArQ1AbN7giDj1LJZm6adD4TwosJ2aQISl
         aXq4wPjE1TBIJfGZcZIL3cveJJd30htQDXyJmI6xN3GzF+aiUKL3WU50SgoqmeY8YQ1s
         54OD7Z5qt1gUz24pE7GYpUbVfxK+i6AbaDtYtIwRT/rj89h5qPhYP6cQqzv50dAWW/sG
         s6Dbm874hiafvsblGl9b4C64ycZZCqhlMbuXP1MjwZaryd/8sZfSMToVPD68DbjQPvWG
         R1fE3GiwXcVrpkQgIazaU6UESvZPsaMcGZxxpepRIkrRbrGTCplye6R3C1HbMmc/cLBb
         QJ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkWK3VDhaUiL4sSkSdB5UtRxyzAlA8FysuAbAOK0H3XSaWxDkM6FkwKvPQde3tpTLICo4rOduPBg==@kvack.org
X-Gm-Message-State: AOJu0YxBYUQzrSbfpnQB0EgTlxzFdLC5zGmvCvtYycXTChEwokxBAUwf
	SPhzcTaYbTML26/R+PVi0ADiFRJuDybW+WViNkeZ9jzavbGmzP0O3gPg0ROSuI80PL1kxpBf44S
	w2Cfh7mTpjgT2Qbcx80QIPKqFUrPi7cLWBzVWUs3SHl64pvskajBBdBs68hVfFI2I5i5qp6wjbA
	yaAu/GCcMeNejLPxG4nQpJTxGsY7o=
X-Gm-Gg: ATEYQzzFk8NqQA22oDUUZjFKrIabbUk9LTUY2hzrjN5Zv8jlFvPM8mLq2F5n6rfIj6w
	nkzt3RjRSj72HzwJpetDpCYkPeVYJGoBEvcxRyA5OnTzEjA62nXdsxrxxjOTvKFqslaDYo9ZuKV
	meor4wXOSzAWzPp9wgLV99KotCTn28eHQbR35hftNzbcc/P+7x+MIZSmT+Zb4gACYlq9q+M1da+
	fYTjn3PUbJ8xl5N+CxSg3His66/DJDPjwHQHZMWnnizPpyEd/Y8V+o8C2LtZ5IUzw==
X-Received: by 2002:a05:690c:4986:b0:798:61a4:e2cc with SMTP id 00721157ae682-798855a41d7mr139268237b3.34.1772541163336;
        Tue, 03 Mar 2026 04:32:43 -0800 (PST)
X-Received: by 2002:a05:690c:4986:b0:798:61a4:e2cc with SMTP id
 00721157ae682-798855a41d7mr139267957b3.34.1772541162941; Tue, 03 Mar 2026
 04:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20260303101717.27224-1-jack@suse.cz> <20260303103406.4355-43-jack@suse.cz>
In-Reply-To: <20260303103406.4355-43-jack@suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 3 Mar 2026 13:32:31 +0100
X-Gm-Features: AaiRm51g_TgIhOkGLCDR-668UB9OmDW-WHgYo8dNTw7KZZwkVFcUvPwu-AmQRn4
Message-ID: <CAHc6FU61tUwnFf4pXWun_nLnL2jyUYHLKAN7C1hanbKk0GTZMA@mail.gmail.com>
Subject: Re: [PATCH 11/32] gfs2: Don't zero i_private_data
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, gfs2@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jvNQw5Hn1OYRgAiOIf7BeYAYkZymwr6Pf-y7jieKnAU_1772541163
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 954281C000E
X-Rspamd-Server: rspam08
X-Stat-Signature: wtn89hgk5r7c3u78f1hye6wzqj7rdkgr
X-HE-Tag: 1772541167-156679
X-HE-Meta: U2FsdGVkX1+TuY0T6gpJBY/kYKnjs5Q7ScO3mw+8OoI7W6+1JzmLiOLimLVWPsJGJyoinGSCZtFvRFC2GkPYXblxWgs/y03UvN8mJt+00hQUE0pw+qYCcVmK1o6I8w6KivhmRRs1yi5sq9a/DgnFFzUBJYU4c4L+enYnG4aDJjbHETwcL/MPACxabespmcoHPNvycinn7IwgPslwS12V+zySNd0EqyfLjxVbOK3alN9utPxB934mvRw3yXZOgisdupnvdP5QtlqQLynS37bNQbo+HjyhF9S6KE3dRhcUyyr+FD+VF04hO6VJ/7vvTLV94s7RxduO9Ut7sRa5WYgRRoDM3JzVOQWyaDu3It2CcvadYOh5l3h7VLM8gGdvx4VmoaNR4G1R0cPjCV9sW8HXWyqsq8Lbw6m5VSePuXNcNSx298OqpTXq08eLfGtimBqi/PL2pzcIJiI3aK7+jQO1bWy1StTFPtg74aYXeanOYt3xZwYR7jqa+LZvJOwPCMZrH8ecGAXVzsc7V3vnH9Esfj95p9+v8jo4gbw9xtFyOGa5rt/vG50plDFzK6CQqwseUZjWXtwQof48h9byWrQBLJIizN0r8c4Nk16FshBOwOA1P6PaQDpLOsQfxVAYiZAm295sx0+yKw+Y5v5BzEMBAYd1oWdowh/bUA6nwxUIWGqokEnbRWDm8pyg/RWzECc5HDd45ifoLBuooUem9rDFhpiLzr4eOfc6AEmYpeMxPvbPFJ93bd4OuAd3UDhpy1lz79VDvpjSWw7HHaSJKSVO3Pf3SFNBolDoUF+asgqXkrkljvXatJn0eJnNMAf7NceDXaC8Ow1Drjx39Jxh+b/JtFAsF/doRvuQ8AAxMlwdVY3oyISgX3q734D8yG5HozHGOuZJZfQtTVAs8xVCerc7DUhwLYPj9XktFNnOZwOCuzePHjcVWXZ4ozDgUENRurHaQvzEdPgrrfCZc0QEEV7
 wSbJFi1N
 MEaJntVULPGHDqg8DGW89IsxYDPXhNbg/c0YqS4NiY39k/hriIlQDK92RXCxYjPof/XKN8urcCT2GTJgZrqzFD1r2CJy6N9xFugoZ8ZZ34BJjWuKGyzT3stwG7oGvfaLwA9ZwUuosFq2TJTIrApmmgLzRhkD3opPJYedr35MIvnJ5VbaPVWNBg1Ib5W6OG3HtR7G4hMIfVM2Cz97lggF4ENHmwm/RMnObk27o3ojX1SvKDB62B7sEGdQGvdLxjoyeIKvjep87ha+FkMvx300wsyH56LAFfYVIL7IO/7jrNmAwI+so6b6Jk6ayfAUOgoNd+kHQEDoJgCsUeKZ1Gx6/F3G8NL76qZ4qCTplQM24SE7bHYDlRdaR/fqjfv/pw/LQo+CYJGSS/kOS5fuM8gzYUWGZ1LCDIyLBAEypSFIRcH2s4qhvBKljCnijeROxytqGxjHPfmczKTqejydOsBlADDp3isNRwyTN2JX2Z1wa0iziDvqKF82B34wreNP88FvJ4dJG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan,

On Tue, Mar 3, 2026 at 11:34=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> The zeroing is the only use within gfs2 so it is pointless.

"Remove the explicit zeroing of mapping->i_private_data since this
field is no longer used."

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas


