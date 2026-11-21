Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFCF60A260F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lurZZMoy
Received: by kanga.kvack.org (Postfix)
	id 7CDCE6B05B8; Fri, 20 Nov 2026 20:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79ED16B05B9; Fri, 20 Nov 2026 20:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6036B05BA; Fri, 20 Nov 2026 20:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4825D6B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:19:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEF10A7B1E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:19:40 +0000 (UTC)
X-FDA: 85457368920.21.D3312DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DE2D180003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:19:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lurZZMoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223979;
	b=yAfB11QvuJGCvL0fT3Z23yAMyy6L52TW/i8h//61e8ZYIo/odXX8AlAiqtc3IZS5Gobp+B
	UvZIY0SeQ1AHWlqOfBUJMchr6FD8vNa9Mk2TlVWbCxHB8Ccnj/IhxC/efriG16DeOtFB8E
	OSeNojvGURoM+QDCxwKFXiPXoZwlnhw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAnIPQrHw99t3poEK0Gyi6LO0YpQyQO6UetCOpTe8Oo=;
	b=GF7o7sF6BTYjY1vHtHP6bqarpuEcfrb3XYrM44YsFK3g6qNt/m3UXVCboOcPyQO/vBH8kl
	8pVi0wYTy7896XIRoNOKYmhbEeGBjjHsLwvSc/cL79bvKU9/No8Zh1Io5oraNLeRIcU9zS
	0rfOxWSv5dERBuvv93frJZ680fZvkaY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lurZZMoy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 4F76B404E0;
	Sat, 21 Nov 2026 01:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CBAA1F000CA;
	Sat, 21 Nov 2026 01:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223978;
	bh=sAnIPQrHw99t3poEK0Gyi6LO0YpQyQO6UetCOpTe8Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lurZZMoyYWuE9VFyNbq3lpHmBso1FtIfC4Lm5o/hP5nH13VYo2ikC0PxUrVuDeqRD
	 zhaXUEgHcooKj1ejGHybRCzXAMBVS57232dlmf4nyZ1LACxIZrpiXlbzwuqHYmZm+n
	 A9srb4NyYfKiXRxRXXawmMnQEMiL09ChNNRQb4pq+FOit3RN160L4rE+F9oOXIvJ/o
	 P034ab/AJBn8KDsIpzFhKvrOoX/KtPWgDlqYLDppY7HHPux9NG8EacFkyz+QDHgBvG
	 9VhJrofYIFh9lsO4tmk3Y0vkFoVgA1AAirmvww76cp/mlfN1QVPT/tXaX06r85/OV0
	 EQWdPpoTzi9cw==
Date: Sat, 21 Nov 2026 03:19:34 +0200
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
Message-ID: <awDxps7uLbikjV5B@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-16-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-16-jarkko@kernel.org>
X-Stat-Signature: pew4xw8wmxok79ssxaiqdh367op8b83i
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4DE2D180003
X-HE-Tag: 1795223979-798365
X-HE-Meta: U2FsdGVkX19MOHrDsoR94AfGxJZ6DxL2rcAu4LHHwSUT8FaTWdGZN0TBKpuJrc4fQWABdGmJCVLBOCEB9zmZQPF/zUVNwY2tPN1tPMnWr8Jcsvnw0J0bqrBu09nkXNt9F0qfoBqb1IZxvsCwq+JomaG61HabPYO6dgTjINObbng/Mbzs9tV5gMj1jQhgQ1+cZXEx0Oj+0hbOP8dsoDaG+7oUin+nwqBBDXncpBaxGs1eDnC62WKEDJ1j10eUA2cJcKc4Qs/NcfI/h1xYm4e6FdBWt7uOaU28hEKa+F5hhRX6AZi9O7nRbvkUfJE1J+GqkwTo2Tc47+kQldhruZmRw6DqXazkzT1k5H9hdf2pv9dDXznRwSw/cTHKP40aUjCX3B0SDu0PkouoXRJoNpPYddCm6GnzWVt2wGOmhtuOPpTuCHP218OnEjW0IfpCbTdRa07fqZjVVP3SIwyo8LXXvAg2PwGIS8gQ4Ka95al4r3pOeQMGu2aZ5+ntiXyJfybtxMoT6kHxuF5FfkGu/qOg+b3T1XHDepSNjRi5AZl2o/BS9QOI0RZh6KGKuVPTb93SfSWf5Z+OafIBEuMp04QAieMMhfkJ1aDsNdmY2dgcWXUbC510vlaUvMPF/O6dp7MJzYwwbtsHoenUuWyQjd6jwtJNgkAtPEYnZ4uQ+PuF1GBvPwlbuYGaG7Rlj6m20IP4xN26WJuG1NxpszACuVazmMxsWotSxtEJFAcQpJgPX+Xt258Y5G16dExYcabe5ybwqNhlOuvLBPZFVnQAN5adpP78wDSyi6Y6yrjZ6hwBaO1QrX80AGPxT3Ee4cmuBtcofWYovwDi2LVIwWVuVs6Ot8TmFNGkJhc0GjzTNX0g5bq2mSR63b7qAf1ckcL31lTq61s/IMX704w+b7y5OgOeZWAIEQqoL8Kt+3TVh1J2/atCzaVplNuPvp9whcX1g6mqF0LNjtUJZGE3DMB8k5L
 zN5eaQP7
 F3bbrXXqqy/TnkZgllbSgzickxDuaIuUuvD6MkAy4AR8hIi1xeptUH+KQcB6ukjowW/fZ18J7BLhH2v4h1hytJFmp1lfDnTVoePAqecB5Xz8hMoOcY8fXxyo81rNgjMkGsMkI7IXTJUAs6pNtIa/XHjRAoSagsuJx21hbu/kBh9mpgSNj91WQmHGaJcINoPI5pBVaz278SdkB27sgwvVfG1uv4WU8u1WhMmNoI3y5/PqhKbM+Rw+1fXY6lEAJzKcCHBdovnTP+MaqSQZjb5qBo1LNrfSsOM2hDu4gJ8lGYdPfsHi4QiYPRgLKGwpT4eZmRPQflVUpO6BfBCOXxRLdvpSmGPwzxIK5/ivDc8q53By5uK8HQxrB8yXvLCT7Nnzam1dHosBrsB/jpxYgDQ4m+HEy+EIFD3PcykM74AK3ppn9aQ+loI4YRdOgO7CH+NaecDHohgzgGj4J0l+1seZoSf8b+mnM+blcCEOpyQoEPyeRHaTydFJxF+QBi/WU/rdqqqDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:34AM +0200, Jarkko Sakkinen wrote:
> Signaling every process inside a container from userspace via /proc is
> racy against concurrent fork() calls.
> 
> Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
> walk the root namespace's PID namespace IDR under tasklist_lock, and
> deliver a validated signal once to each thread group including in-flight
> forks, aggregating per-process delivery results.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Will be gone i.e., can do also  pidfd_send_signal(fd, signum, NULL, 0).

Br, Jarkko 

