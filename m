Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A60FEA3F2F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E5A6B0005; Tue, 10 Feb 2026 04:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC7D6B0088; Tue, 10 Feb 2026 04:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB1F6B0089; Tue, 10 Feb 2026 04:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4621E6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:48:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E35CD1B3507
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:48:26 +0000 (UTC)
X-FDA: 84428071812.25.B45F3A2
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id D32C3C0007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:48:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J6IG7jNx;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770716905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DlsZoRVip+D7R3X4OfoBB69slLASuqjli/DRTFoTD4=;
	b=hWOwrVVYlD/bRV0hnFWPmRFsxPe2vWEEmMc6d0OVa+7gCdbCGkGK9Fsndv35szYHfm08+Z
	kOyVzAF2LPOlXZn3yXyDPphblGApGstmHb6/cCLgJbhI1f3IA5v/3K5zMPRI47pXGY0sD/
	LTNEr/vOC18OLsBCW0/l8yt/L6RCxlU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J6IG7jNx;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770716905; a=rsa-sha256;
	cv=none;
	b=VVmb3vG8lenjO3bEdr3zdEvcBz1y+s6zOLzbsW71OlrikSuFnET/JCSmnwwb6C/VxHdsRU
	ZnqbPPqV3L9+MG8Nr+oSktfodnf/a+95Ix2lcoSEBzEGD/az9WAjEMxrcoYr/Onj94xVmA
	yz91JWYuWgFUNWiZiHxCSdH0sLRj2Ek=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-436356740e6so3071461f8f.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770716903; x=1771321703; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DlsZoRVip+D7R3X4OfoBB69slLASuqjli/DRTFoTD4=;
        b=J6IG7jNxgcNDL+DG5ZR5Jr5QP8RaFh5KifupCk+h/rwicV822sNrUcyeFxT2pqmQpH
         nUYvinvVp2Yu5gqXWd54/chpPVjq5/VuUxZw8jkG5B3B7cm9k7aVnyp+lfOelo0TqtWf
         9E4sGWYPYV85T67RFCUdbtRHs1hifqCVMd1KGsdiHrqjKD5RwKTrc5viEhHMvr1K2vwZ
         bQypt6DzbIdmuMEC+IpuzDRv45slKh2xbPwb3Lh7qwrO5QK71qaqwtLFq/zvpgJRQjis
         GTdVicKFNvVhEG6VtWo02Iqx+N9KOmew3lRi0eLKfR5UWa4WKhIIEjE8ErDlAI2ywg0B
         QemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770716903; x=1771321703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DlsZoRVip+D7R3X4OfoBB69slLASuqjli/DRTFoTD4=;
        b=c6rAq5GctqrXhCmdyax6/50PErgVX4TuXecjXa4rGHze6j2SJ9E91NNrMjwUdvl5Jj
         EA8ScwBSZ8yS+tCI8f3QPXOPFZS+/EFoNFrxGuLl3GGrbXi3Ro1eWwZezqtZtVKbVleX
         p55SCOSgwbOJXcFqkNumERoXJiOLDtp8Nc6+r1KTqyOUahqq5kr8hj3Ei68YwPPEBtCx
         8Get1R8+BqS7Px8MSY7vIl6XeH6dnL7GT5DouZrvNDUM0VMokrKnEGjtCkOcwY5/Od5Q
         EPkgZdd1zHpoK2xbwaptKhBmFnLJ0mbwR809WoJxXnrEDBf9es3tJdTt0e/m0Rm5CnhG
         hf8w==
X-Forwarded-Encrypted: i=1; AJvYcCWcZ4Reoio9AAvCAUNZ0ymSuN8D9Ln7eZ7HA5oyAOtJZj5vCmarnVrdiriTk2cpJqwYxMUv8M77bg==@kvack.org
X-Gm-Message-State: AOJu0YwlYiaDdBd65/GkesJ3OX+p3clLsJ5EORDu+OUpHoZV2PDGQcMm
	oLa3mZdUJMxMBq67dClLh6XNxittUsOeZBq1VqwNzxsZuTi+QBWiBOMbFJWvegZIN5E=
X-Gm-Gg: AZuq6aKvGnbd8UKDE+mgbk8OiYgnvJCFT4M2apAtSbpyn6GKr1p3hNnPUVN0XPcdXwX
	SKiy7OFNbtA6o9tj/gP0EklBZj6FI9Ewj+8tgJIFwW3wY9RwGz7TolqNzcm8/Zxgz19QxxP/tCb
	JfLc6y963vAeu8Ml+wqkyiJOne8hIRDvnu5kfM3ytZsv/WkeRlv9X5sU6SzxCUkuro0wYfNSJkG
	snOzwums/Qg0g1iKulo1IP5TRTG2an1jFJptSB1anEUg7hJAeR7NguKte9Q6BjMf1buvLtAfD4d
	jbQhVC/yED6x3PVzHL2uriZzTdv7ukN5bU5FQ8WOuyPtayrehpPPf2SEqVuKpI4o4pShE8VNc5X
	KO1lCvM+sBxyB+6YPEB08RTCFc10jUEZbQdpTXa59houbeamEG3M5cLCOajkQz7KFwpHHLuMS2K
	EYu/7wPn3+VWAUNjQ6FpcHzCA4Uw8A36/5ofaa9It7zbKiO4S6tUaGfA==
X-Received: by 2002:a05:6000:40e1:b0:435:e440:f518 with SMTP id ffacd0b85a97d-4362938c570mr22915261f8f.54.1770716903032;
        Tue, 10 Feb 2026 01:48:23 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-437699bc1cdsm18679000f8f.7.2026.02.10.01.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 01:48:22 -0800 (PST)
Date: Tue, 10 Feb 2026 10:48:19 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, criu@lists.linux.dev, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
Message-ID: <ilki5auwqeipwwolu7zgmj2wn2wd5t4saa5mtazn57egz45xbm@j4rl4bufrs2w>
References: <20260209190605.1564597-1-avagin@google.com>
 <20260209190605.1564597-4-avagin@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6mfjdav2fdcypbkr"
Content-Disposition: inline
In-Reply-To: <20260209190605.1564597-4-avagin@google.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4u4rhqf64iembj67w7eqcihpr9f4te45
X-Rspamd-Queue-Id: D32C3C0007
X-Rspam-User: 
X-HE-Tag: 1770716904-996809
X-HE-Meta: U2FsdGVkX1+w1oOSDJuJyoDoGSxFNrFwyWHnSsraLSs4j6+4xDu6fNk8sIOT523DFT3/K4/GVFoFx4NCS5c0l3GMgweWDVg7Z8iSDBctfE2QH4n/H48gX8S5XeXHBrLye6AX+dS3aa79ZGps0lAjBCoSjDvlnz0yiKVgxng6Jmxi9ydpChDkzxcdyoSYNfScxvfBReVdfJTEsBDh1m3KKrCC71xqHaCwlNj/spffnPB6s+hrUWZVgHFxiplZfImOqNGm8gmwdHuYu7s35Bwh7Via+NWI1IIvQGIzyLdZgiPsSk8hVYq1LGVQnFYGmIeLJfbBU3NWJQhBh4vyetAOxZvio0KMAULpE3/Pba8V8f66JlMVBAoSsU9aYLh8Y7dICYa4rTHmeUICYa/+CypQta0NTl7D0HswP3Mw3497pvy6ceJt63VIJUoAwmNxBK43qQpMoJo01ee32GY2VWBSdfklEjX0uTUWfoACFi0MG7BJNgWa5DEgSw5AFv0Dnx4JR4DghifICd4VaNNTHxp0jjk+N6E5kCCSss1lSYNjh4JIFsiqmsALUtHlYT/QrRJAyaBZrfpiorMbEFDOygpOUaJB+6fJ89NUFQzgg+g66EtiQuVK+icBoZtpKudLkZMxy1DToWctwps4GMOWOl/+o/IpDVreqH5Lie15Dv91x9S3jWEpc+gnGx3w4kfb9scgU7AmE5jZ5hLkqfcaAe+Q0tcNm1NTe787hZ5DqSWKP83oNekSQUgtE2VzTT40PYOJnwdZ2yvbgPD9UQDshl0MypIOT69OOmzjh1yWJVCgfeysb7ZZTrscb3BDM1dZWvk4BGV8RN+cy5xJ4dQkHk54AJ1Ge+5iN3UAfpUmeEswO5V8xMlUXQCZbrXwnT9DG2pDgzp4DpA878gwNij02mrLjoI+qCxhXARMsMAFZPog2k97X5Tvz/mHH+96HXW3PkQeYxfTngHzcd3EpBmdGmC
 TeH3WTY/
 2VSJqyRp0KdDzrjqpBcmmmVlWZt8fRNAJR/fvKWmLqbhMbM9bXZTvDfJOmHHj0pRKNPbih7rfyMLS60QcfNflW428Vz0zuL7HrffOsaFXPWMmkbLGrCrzm+plzDRfyHiQq1OvTvg6DKkfMHyEx9ZSesHh+Zvi5QOkwehoQzX2Q2MjwWBiWhwguj0nC0EhBYw9jA0CMrQ0U3E8PH+y25hYzN118a11KdC3So4ikuDHAiXnLUS5yVT4Ota8G314q/hx73hTFsbtysr0ZKmhemv3zFgg5Cd9gGntshG85efk+lbvxDj4ePLJ9Ub3xATPct7YwvN4AdtnECD/Tu3effIj1GsPNpH/TXxQY7FDy06PMOQMoDOXBjpgI4VHJUkq2q6iy7WdV3D1g3OZYHPV7iMJGW7wovWLK6lm2qFXlUSb+WV7FccER2iqtw712I4D9ZW3INCerWtMbD7fL50dEXx7JeP81e8igXo4XevQs7ZtnrsddYxG9skNPTtZNlRwvcfGQLF+c9U6QN4MvQucIogMVPhHOF2VGvVyZEARHWFrBThe2Zd2Ma612Qm+0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6mfjdav2fdcypbkr
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
MIME-Version: 1.0

On Mon, Feb 09, 2026 at 07:06:04PM +0000, Andrei Vagin <avagin@google.com> =
wrote:
> The mm->saved_auxv array stores the auxiliary vector, which can be
> modified via prctl(PR_SET_MM_AUXV) or prctl(PR_SET_MM_MAP). Previously,
> accesses to saved_auxv were not synchronized. This was a intentional
> trade-off, as the vector was only used to provide information to
> userspace via /proc/PID/auxv or prctl(PR_GET_AUXV), and consistency
> between the auxv values left to userspace.
>=20
> With the introduction of hardware capability (HWCAP) inheritance during
> execve, the kernel now relies on the contents of saved_auxv to configure
> the execution environment of new processes.  An unsynchronized read
> during execve could result in a new process inheriting an inconsistent
> set of capabilities if the parent process updates its auxiliary vector
> concurrently.
>=20
> While it is still not strictly required to guarantee the consistency of
> auxv values on the kernel side, doing so is relatively straightforward.
> This change implements synchronization using arg_lock.

(For the clarification, I didn't consider the lack of synchronization a
blocker after your previous explanation. Nevertheless)

Thanks for explicit sync.

One little nit is a missing hunk like below.


--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1205,11 +1205,10 @@ struct mm_struct {
                spinlock_t arg_lock; /* protect the below fields */

                unsigned long start_code, end_code, start_data, end_data;
                unsigned long start_brk, brk, start_stack;
                unsigned long arg_start, arg_end, env_start, env_end;
-
                unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/=
auxv */

 #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
                /* the ABI-related flags from the ELF header. Used for core=
 dump */
                unsigned long saved_e_flags;



>=20
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/exec.c      |  8 ++++++--
>  fs/proc/base.c | 12 +++++++++---
>  kernel/fork.c  |  7 ++++++-
>  kernel/sys.c   | 29 ++++++++++++++---------------
>  4 files changed, 35 insertions(+), 21 deletions(-)

I can say
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--6mfjdav2fdcypbkr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaYr+3xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ahy5AD6AjG6/lGRDcame2K5XvP7
OVrWBpsfcwrnZvTHPoeV5UEBAKfBhTRrU7E6giMU6hZF3QDs2zNto4n4tSR+Kbn1
4ecB
=sc7Y
-----END PGP SIGNATURE-----

--6mfjdav2fdcypbkr--

