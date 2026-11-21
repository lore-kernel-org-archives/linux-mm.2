Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B03606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gizXyHcG
Received: by kanga.kvack.org (Postfix)
	id A5B4C6B05B1; Sat, 21 Nov 2026 13:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BF96B05B2; Sat, 21 Nov 2026 13:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924D06B05B3; Sat, 21 Nov 2026 13:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 717C36B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC39DC0306
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:12:40 +0000 (UTC)
X-FDA: 85459921680.08.58E5830
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50AA8A000C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:12:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gizXyHcG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795284759;
	b=zaoGnFvn64GvSK3RagpxVMomsAFYxVEspQVIiRDWyQ6G1gYLVpWUkAR4TmocIZnae613Zp
	OrflpiG/G7IKsCsMeSWU+uSRWYJUpnP9tLSGB9eULFstp5d10GP7rzLBhT3mYHFTkr0nJV
	V+7/dbUA+V7g4WNHCLWGmPVZOtd2k/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795284759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykgUhZMzGN/x6qhqJXjutPzw/2bCyhgJYf32RJRH3+8=;
	b=fC1kHIMTDOoDtO5epVbz+hXZdQH7sdpy1VGGci+4B85DVafm8VBR1+iqEghvRW7LiP2jKT
	dr6hl16gJhXvqiKzNIOR9QvDZZVX5TqzCZ/KrFnpp7664hSMTCIK9sjgm4kQwonIz6wsqT
	WjPkX2paiWKQaYdHWD7tqKfUCnYs8G0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gizXyHcG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9487A4483A;
	Sat, 21 Nov 2026 18:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC9AB1F000C0;
	Sat, 21 Nov 2026 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795284758;
	bh=ykgUhZMzGN/x6qhqJXjutPzw/2bCyhgJYf32RJRH3+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gizXyHcGyrGFgvHEvIb9lBxy4s1YyUMohTsz1YR1Kjs4SBFw7IQhXrX2OT1wM3S5u
	 UzRI3Gypn4jjecAF62TMtKRjzuWDeJKF3tHlEkR8dHOQO71qen2XaMaRXuZ2JwxGe3
	 SUFeClDq3oJQk0WXNB5Ijq4r/aiPanGP+qW2kCO69BVJyeM8uDii2aPFbmtzCctv5M
	 edz8R1joRKw3mfPuioJyw3oDqceUDETJpPLdiPZL9XazsMe4uyyTuoYRGE3drNdEvu
	 3xDY8vdIAOR/GMOSD8oHVS7BRyXA2i/6lRMXxIclEY+fZP9bJot+0RauhBALLOEWHD
	 xxyHgZ7Fzhbrw==
Date: Sat, 21 Nov 2026 20:12:34 +0200
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
Subject: Re: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
Message-ID: <awHfEvlmG8XEGaam@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-4-jarkko@kernel.org>
 <awG_nK9E-UjkVgK6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awG_nK9E-UjkVgK6@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 50AA8A000C
X-Stat-Signature: dany8d1kxpdthghin14tz4e4t89mnthe
X-HE-Tag: 1795284759-62393
X-HE-Meta: U2FsdGVkX1/pxYJKsnbFqqQqfZyC1SkSsr9V/xd5o097UUyftbXulDNuNjClfpMudko3tYyTNanncYkraJWhsjn+zNX7PZuDePsKEfW1p/3THNwndtM3y0EJRXJlGcjXRqymxYxFTWWgVVNkD846+TjgBoVaFhfM4aclzX8tr/a9NJ0nCmo0ZaWT18TCfWHHwD2pz8ZOjdZBMVPBIUMDwzJC0n5jUCMX/QwkcZ++/6TG5tWotsst/Ymy4PDh51UTNas7ArZyI1/UktEZeTlU98Xczt1GCE/WdLx0ekk7uuOdFcXW/XrE8zOzwpeA9EW3F/M5dNMJN7X0tolLYJvQZEU+DmjWMLr+wr1tvwuBF2hjQvONkRW9i8Gf6AAarANGOpSa9fTOoraPrGp6Qy2E40X8dqPLuSptvWxiHDTIZJ1Jdm4MiwKzCHx+YOIyzKz011n1N7pMGFt6xOg6DclpBxKfJwlwXP0V8+R8+8N1DNz2BSjDFCPU20K94Tqh1oieLXIS2Ab0N23910v9OJIBDQasp5Ww6JvcSQMwV8dQ9TUXuBwI2vFb+jMqCnaTZB4MOjZmA66ZQSlF5pwLWG33bskiBJJ08ZEFoKEbURycPxdDXUopBMy7dZRsQWlN978iWCXnseCMj+YcxebDIvM9shdnHfz4Jjuf83PfSXHio+3jYnBwuaEgs0MV9rwQE/CXPItPLh0XHmWyTy6yJWyWdO5Y23U/1CFdegM5+tjbJYyYMIeGb/EMX8kBpQwsHX4aNlQSiSsKKBZpBxlWxwTuDzzDFCIN4T+/53kHC7XLHRWEiQQ87Kzd01y6ma//5W1D/ovpxLD1IQihUKycasquhOxqBFK55zi6CGMGqphTo1azpeU6kGkh4hL1XqLL/jVaWck+X4Kj8C0VnuDjC6zBqOL34vTnFm8xExyz98DeI07xpPKR3KX/G7Qmog1sCwF7cXa8lRCqTj3BOqr6hSj
 XR17gtmj
 XAjk8rlnPVAZwtuuLmdTxLYPy+1hDZYR9B68P4eEze9nNU6y4gMII/BDPKcbPIWSNemiaEawvWFbA/MTjFSad7p98939RtFqPNd6YXUnqnGIaf6AXFFfcDq/fq5Am3gACm9N3BhA8vA5UnTfaRajuD9tPUiUTG6RwEoxP221/oG7o8/MT0N1FNKM/0bGZ63ACbEm2qYJ+rPVV4nH7p8cnjuyMnK8mZ3oBngaGIFDZvovM76V3dYhizEdsfAfk+rcg4wSungLMb6ol5jm3gOs9Fyeju8MvnDrYaAe7xv6Hzqb308SXX07f9mZFILHvK7DwTWWg0uqPwukrvbUsagncAOVB2b6REs4+M5BiWsU+Su736AZbqd6kfSfivzn3TfcOgVTC1AtK+HE79SzhG6eLTPGcV1+obgsMY3JFJiPMa456PZgJHktNUrEVrruWu+ue6McXvCCCqf9Bb4kTo4RxRl5sH7b4TOfywyCXmYCCxNbsu5SUGfGL9pHlpgLSxnr6Qx/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 05:58:24PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:22AM +0200, Jarkko Sakkinen wrote:
> > Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
> > system call tables and asm-generic unistd.h.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
> >  arch/arm/tools/syscall.tbl                  | 1 +
> >  arch/arm64/tools/syscall_32.tbl             | 1 +
> >  arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
> >  arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
> >  arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
> >  arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
> >  arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
> >  arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
> >  arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
> >  arch/s390/kernel/syscalls/syscall.tbl       | 1 +
> >  arch/sh/kernel/syscalls/syscall.tbl         | 1 +
> >  arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
> >  arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
> >  arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
> >  arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
> >  include/uapi/asm-generic/unistd.h           | 6 +++++-
> >  scripts/syscall.tbl                         | 1 +
> >  18 files changed, 22 insertions(+), 1 deletion(-)
> 
> I'll populate remaining arch's at the time when I split this. It has
> enough coverage for the time being.

Ugh, I have all populated but I found some other issues to fixup while
checking this.

Br, Jarkko

