Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D058606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mB0YRm3j
Received: by kanga.kvack.org (Postfix)
	id 7FA6E6B00EF; Sat, 21 Nov 2026 06:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784056B05B0; Sat, 21 Nov 2026 06:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C736B05B1; Sat, 21 Nov 2026 06:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41CEA6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:24:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47D098047E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:24:21 +0000 (UTC)
X-FDA: 85458892722.09.14B0396
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A988940007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:24:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mB0YRm3j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795260259;
	b=0NDfAaSHp/SHqlnNd7E/M8pi5VYdxwSheFy0/9GKyDEDN8kydgicby457Wpp+scepP6he8
	myppyj5tLc3ej7wt9InuSKNZSrjKvwtV12t1KjE8ydWOMK5lEHCufY8QVVVtuzDwlbBthc
	6igjVt/2Un8Kc1UPV+EbjPEj9PzpKR8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795260259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHbQtC6gIc0jGnYZ6s00mCvjyoI1Kvae0ypDCzK5JU0=;
	b=r1ZSNLFCSGRFFH59cFPt4z2DxYn8Lq93uFv3dv/zjhE9mXUqnRFRYRsxkAp0fIlVuSTLs/
	MU06VnQJB/cl4DCzapC/tOpf+CJnrlem5mEPfMme8gc+iZIT9ohCmtFVAwfuJ7PPWcVdkY
	0k9sp+JJHfZfPLYL+sOcv0WplkCh2Q0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mB0YRm3j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id C59F860D36;
	Sat, 21 Nov 2026 11:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EFF371F000C4;
	Sat, 21 Nov 2026 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795260258;
	bh=GHbQtC6gIc0jGnYZ6s00mCvjyoI1Kvae0ypDCzK5JU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mB0YRm3jiQg6+dAG4Uh+kh+x0CIpL21NhV92OyKjRc4Nza2T3tFWotVyy2F3LVDkP
	 TDWkq9Ns3VJKWe9ABDZH8j4zYwrx7d9HbeCjrlBUun5+r7vTyh0N/tLEKFB5z8ICp8
	 qxYpXHkhVSTOh/LCRPqYeZKg+ZB7e4/9BbBfT5R9OcvwUtzYXz4ilD9CAeuOvXx81g
	 Dp8xUFM1/TAxBbErZPKEA/4uf/7MxVON2JR7/HEbHbLOa29JUDaZ2np/MQ/wBSCjBn
	 X1ArG35BUmmZXAPBQRSM66IPm6GHxeW8BlPy0LNZdkeKdtQiZyQ44rkuf+WoHNXFGO
	 8tMX0FG52frPQ==
Date: Sat, 21 Nov 2026 13:24:14 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
Message-ID: <awF_XiObSZVSARoh@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-16-jarkko@kernel.org>
 <awDxps7uLbikjV5B@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awDxps7uLbikjV5B@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A988940007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: niqbjewcjxdoxoh4bw74fpyanhcm7mm8
X-HE-Tag: 1795260259-967214
X-HE-Meta: U2FsdGVkX19pRQ2Fisi7cjBLcMAdYf5RLc3wItPA7zULM9SsSQxlL2Vso/3icBNaQidYCO2qyhOUYy9CZTCGWKBb7W+F76tzYL2mNtD+yux7qXBl+Qey1M1yVoVoNb6A3dNDkJowJ9r50wnwwLG5I13E49jNOoCKoDFKk9FGxMvqNIRkDpNgfCxLTyeBgnBZHHdmlGhatg4Yx3JIkLdbFV3et5zG3zfwUex7VHudakypNTmnXoOv2H0pZpyn0GLLVPhUuaOCoTmrBB0q9rx+gIjJQa8p7jz56P2ruZeXn0sDgQ1dacIz2PolqAhNyVk1gFnNB9mYUEODBierodKZyIqt2wKrqaB7pVHXHTYLCv8o6MV3BJAC76QnwdvZylDw+0TEeR3HfygKH2WnoImejqV824hPeymYwbC6iMznoej6h9guhoEVNIfEJIPQmX0e4cHH4KYJLczCKSbBlQZ2abvsQY318PSk990HTu1mL3J4JsLoAwcHOMySXEsZf+zgaWSJ9K4hE94Dx1LsARw6fdspfT9TtLi+s9uRg8l+aeLAIe9ehXlGN86dbCUMCOZiS8mQbRzUCxvlyPrheEMghshRGp0X1I+R5exjcgtiIiPquX5iMXkR7hPmk3UU7bCI3MgFkruigVPeTgvWCaQFPKW7LMtazQEjzTSYNfsMAJcBaXcviTzxF9Jw1FSQphCIfymArRBEgCRyDxxDVIlaTvyRBSI3BIfeFkuO8GyY57BI1FOAarHkM1NHLAwM9pdIv381ez9ou0+xp8Cr1OQLTA4nhnAQ+RFrK5ZdIwP9QoIb+XSBaWYAMjgDrIMo80CMS2LiGP9vadHFYrg5kJ+/VTQjwRHfJVCO2trhGCzd+v5uthUtqskZkz6u8QCEvxQMSnlTsgAcymldyECsOxATI5n7vNdm3oYykYx3GyDATX0xP9QOsLWzaP/zzS5YitT3MOQc5QrU4KjzLoBrlzX
 5oDgzSuR
 mQAQKn5eg8LAGPYXCCLMa8GDSCfZXCUTHUB/GRTRqchpq/b+i+jClsBR+Wjb52HOttbkfsirQxearadWPYj2bPovKFbJZJHJ/P75Q2OJIkgVmdMe9oXk9ejX1MnuNahmLpoC+4XpNe5wTP7ysTW/KYlSfrqhDZDogRYAdgiAYR8xUM4V1oiZRZfgoWXTedXWZ7GnwSK0htS0Ndf4t+CNw1q33fSevKyWjXrEQDJaIAUxaL4CSwW2QOfNgr8YqbCz2fZGFj7aAbNDS/4FLpPsrst3fIj6hEMzbr46XD/rxcjSfW8grseymoH/+nddG+sz2M49kJ3AlAdDqTOVCy36iqb1JWwQYMatqA03RvDoig/vXknsu7/8ZiS7VI5+xEGdlV/48cbQ3zjJnchXTnf0VwLXzb7WJmhLIMscO4uqkgnsn6S55zofFAXUftDWA8XFKHxY33fTLS3EyqezLwPqLVoInBtXBg6Ycnqr4fhuPjAb+kJzBxfSfDSUUZajOfLOycnWV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 03:19:38AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:34AM +0200, Jarkko Sakkinen wrote:
> > Signaling every process inside a container from userspace via /proc is
> > racy against concurrent fork() calls.
> > 
> > Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
> > walk the root namespace's PID namespace IDR under tasklist_lock, and
> > deliver a validated signal once to each thread group including in-flight
> > forks, aggregating per-process delivery results.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Will be gone i.e., can do also  pidfd_send_signal(fd, signum, NULL, 0).

Wiring:

        case PIDFD_SELF_THREAD_GROUP:
                pid = get_task_pid(current, PIDTYPE_TGID);
                type = PIDTYPE_TGID;
                break;
        default: {
                CLASS(fd, f)(pidfd);
                if (fd_empty(f))
                        return -EBADF;

                if (is_rootns_file(fd_file(f)))
                        return rootns_send_signal(fd_file(f), sig, info, flags);

After this only ROONTS_GET_NSFD remains.

Br, Jarkko

