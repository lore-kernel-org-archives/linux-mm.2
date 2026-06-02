Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F24CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C734B6B03F1; Tue,  2 Jun 2026 04:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C239C6B03F6; Tue,  2 Jun 2026 04:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12846B03F7; Tue,  2 Jun 2026 04:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D50E6B03F1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:13:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FAC81405AF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:48 +0000 (UTC)
X-FDA: 84834258936.06.205FBB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9BA0100009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5l423uq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW1Jb2lq0jvXU9cqHaR15Ee40aqegmEDFgHV902Wtbg=;
	b=2mXVruf+/eFRHNzC6qP+236s8unPwv0LTfpOSZVWVVNqvAtg5lXtPYJe4IpU4g9eXB0Z9z
	mVsAWM/1xDYHhoCAXrogX4M9V4hPoa1QNqKbmwl+PEGupmcINAEy7EelikQBQSsse4cEI4
	RGFGMSTm1KaCfkdc+ELEwLaPS9PFL5s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5l423uq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388026;
	b=sDc3olCw1x4899TnXWOTtAl+TZlcJW1ePgT8JkMDxJ9VT8+garbNxqViF6cdXzE/FL3I7A
	ErdbbcbpmazFkKap2RmgcYd7sTmFuUEydCH/NgulPsxblMcBfuuKq5YWEXfOtLTF2/dPMG
	UZ5hBFtZx0hwauGkbLPtagdNl2Sm3dg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 541F460142;
	Tue,  2 Jun 2026 08:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C81F00899;
	Tue,  2 Jun 2026 08:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388026;
	bh=BW1Jb2lq0jvXU9cqHaR15Ee40aqegmEDFgHV902Wtbg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=a5l423uqgUs0EnF17yDerxYDPl7bPFNzxgCv8msMDTwa01f/VlMfU7kcbBQbByAy+
	 ZwI32LGnWXeITmWZegZCxOgODqaUVPz/jW5kTsJQ2Mnli0wa9y01znNa3fQc6+MtMa
	 zyfgkW4jmI8FrFU7tn7XpS0RJqn1PJwZslDYp8Y4vSxwhG6RZOdHq5U2lArsPGX5GN
	 324Jl+5rfjq8um7r0h3M+aVRP3yd4xZMwbTIsWCuZJ6VGUmWUv4PAmIXFTK0zM/NoM
	 s4nstGFOtfzqOBMk0+1o8FxKpOqXV6yrrJpj2Ooj63CKKnDAgMnjfOBMY28ISAEI7E
	 JXXV591Qj/DFg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 02/13] liveupdate: avoid mixing cleanup guards with
 goto in luo_session_retrieve_fd
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260530221938.115978-3-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-3-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 11:13:34 +0300
Message-Id: <178038801485.119771.9514973100282773342.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: f58nocnydb7m45cmkim54gyddyib85fp
X-Rspamd-Queue-Id: B9BA0100009
X-HE-Tag: 1780388026-286097
X-HE-Meta: U2FsdGVkX1+5jCbKy+nRZagD4otklY94yIfd0thN3ErdwUc7YuVxymXpO5cjGs90QRfLrL6yfM9d4fd0lBYtlfuJD12KIZoVCG5/7R9LhicdvA8AIHRL2vO/5MvH3MJgaDYB7XofWaKOLcWcbxU7jWAl8Tg+tWHA0MPT8MadZF72OuuRHzVqcfGft4+YlILTiYzlH0VkAjO2viPL2MjmWNy7Z99bI7E2jZXTAsmUPVRCLv4VNQrZp6O1xoW4ap6IpsaBbJ+TLLPqS/fdIsiEzyvkTirsSr8y9pz7NtI8r1a5SRWmblIVefsTpFPnpOMlwHtauY5K7wAh/0xFvVBb+EIXFjSwl++ywX6s4XMnAslCZfPw5+faonwzY2fQc3DAGqIFhcsAvXFb6TDHbORAdSrlW5iPbSVa5pym2d7+MiFz0K1zE6Jajzjo9gbswkAN+8Mh6UN/gbcYDkWoVcgkwrNoV5pnqyyn34ptBShqYcRLfVURT68PSG+rvQIauzI7mVSihnbiNUijkfaFMmlKB0mT5RmcIS8n8tZSJc0WmdUMng+x8JvqBnbFKfLn0xJ66eajML+ezmpv5j1pzHgo2QQTjAty9zZ3YZ3358gAexrCy9ifPBn5evxCruRH+egcPs3r7heLIzHuoTCJ5B1CsfybqCZsu4TMkOfXTVxyzXYs1/UQGSTEjKncjbyTWJJecV3jAb0BBmJEIitbGORM1bE9ZqIeIvMpBk/A7PZyKNs0m2KCB8H04C0PPmWWvygDwcDTDScdBakKUKjYdWzGId/Dq4UIG/ngAuRS8BsMr6jWiVBh51QWJno8Ao50dRqrb8mbv4Co3Pp8s9xZfYls/mzwU7tpbNbwzvoyYj5O3FKfT6QLjP9oGv19DSbx7FujNVsmf+hbL/bCh7CqhFdoh5YCqJj4ngf6n7B6AfdiBEmd8VxZU17TKMNNasNdCiQM4+yE5RXM0abQUvzTytr
 hN/7o6qF
 np3YoEO2VBt+BJlENNuPhBbdvqV3We7F3nui24drl59qn5ZjDZquqPNJi1iUneCH5UwnWcarcSW/5lN6go+oFVKTOSd0/fN31uNC9BKcx4aVbYEKc+4XQhkVoSxwbP3XgP7N0JHL/eV8cDxNfOv7jnJq+1xdysuZGQjbXf87eXMab2EDR0ymJsLxbeCXzQ/py85q3m1o9QgaDhnQE6sZbuCP4moWm8p99nP/ONCTp2TwSEMRjU80z6IK9RlNQDZJJEpSe0lBZN8JwzmtSHTTaIoj7J9pc8NighzLkIBrRN2l5OVL0XkbGM++238ViPz04fLlO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 22:19:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 146414933977..8d9201c25412 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -291,25 +291,24 @@ static int luo_session_retrieve_fd(struct luo_session *session,
>  	if (argp->fd < 0)
>  		return argp->fd;
>  
> -	guard(mutex)(&session->mutex);
> -	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> -	if (err < 0)
> -		goto  err_put_fd;
> +	scoped_guard(mutex, &session->mutex) {
> +		err = luo_retrieve_file(&session->file_set, argp->token, &file);
> +		if (err < 0) {
> +			put_unused_fd(argp->fd);
> +			return err;

I don't like piling up error handling inside if (err) statements.

As we only need the lock only for luo_retrieve_file() I think it's better
drop the guard and use goto:


	mutex_lock(&session->mutex);
	err = luo_retrieve_file(&session->file_set, argp->token, &file);
	mutex_unlock(&session->mutex);
	if (err)
		...

-- 
Sincerely yours,
Mike.


