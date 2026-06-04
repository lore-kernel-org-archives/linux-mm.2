Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF202CD6E74
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 17:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB5B6B008A; Thu,  4 Jun 2026 13:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C806B008C; Thu,  4 Jun 2026 13:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B1A6B0092; Thu,  4 Jun 2026 13:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60096B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:26:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68D4D8C732
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:26:11 +0000 (UTC)
X-FDA: 84842908542.22.CE7B991
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F70F1C001B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:26:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=d5XwpwGa;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.175 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780593969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2Ypl5piwY28pT58DbtYmX3qX3B63YsIgDUM1eIk9WU=;
	b=GU41/ead12jLcPEIiJGiFjAg8WHXrh3l/KGM6gV/PF5mQuctBtku5YHYLS0yJ25PoMeZBV
	GwuUzclzaD2JCO0sS2ySLQY9IRKXydrutRCF+f/+ZAca0AsxhlQSv4nu9xW6UctARUbaGg
	c64nNDK5Q5NKUo7PSqRgqbSb/ZCxFCA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=d5XwpwGa;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.175 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780593969;
	b=7CisQxTW5umdTisyaeo+NhT0fFjyizywqOe5vpjarK2sujRfCZkUKWMjPxytakWUlw9gF2
	mcndulV/ZhfHBbGjeNufyQPj6Gyd4p57y8jh4UOMYfKeiVXGRBouz9ZEGgv39kpD7TpXxz
	9nuCVqgWLRVU7DrZa57iWqpDqESdHwQ=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39666aac20cso7830191fa.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 10:26:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780593967; cv=none;
        d=google.com; s=arc-20240605;
        b=LkGcRw5nM1Dw7DeDgwzKKJuVHhztbcAxewp9fuLKDZdjVY+5j+utK7PuGO29bZ5NWN
         NK9JGwWBFBmSClYNabgbME4VIA8rhxOzfHfzfk4pOv+SD+04kTBCvCuhDvL4QybzT69X
         DqKty3+V4jgupAE1xLK+xdyFKI9WHosSM4ZxTS+rP0C30AJ10Q6U1RXcPAWV+UdBTJmM
         Rv641BZTV+05aY9riUP2x1pfkEQxK4PjFmFnIq0LIAs5bkbMH7B7xxVGwiacmX5oiLnq
         IctcTFa5WyK9orA2sPNasd+/DVjnmOKEoxSFWxFm14UeFRe8NOnQrwSARMKyW4CqaW9x
         3Hbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D2Ypl5piwY28pT58DbtYmX3qX3B63YsIgDUM1eIk9WU=;
        fh=FZQm6wZkDJ34Fc+YIvf/biKCEdHYOkvua0RTZlEa1+s=;
        b=Z/4TkjfWSKYX3woNP25RGDtr+BwijG19NKONvBf28OzJ18vBxKmvFBiCFrv2kJortJ
         EDoxQsOCdrTPi1rFbqo3hE377x0H9trrDPAvNTqEKd9R7O6g/lYAmxnt2HrnbzLBE77r
         Jz6mGGiWoYguzcX80k1L9yMGsWusGvFE+X6prfLpkjfq7LcqHm3sKHnSY6xhJ/2ytZAk
         VbXqTZMaXmEhNDVcZ3VgjvttA7QqgtOsbAsN+oYOAuN7J0cgOIomfMbIoEwOsQaPafuV
         GkhLeBB6uPwayCqaJ/fzjC430XUwIQtsT+pGSJ6uandj8HId1DT/K4Nnjh/xUR0Pczc/
         M7ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780593967; x=1781198767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2Ypl5piwY28pT58DbtYmX3qX3B63YsIgDUM1eIk9WU=;
        b=d5XwpwGandMxd3VEYj/Fh9f+pt1ihQ/kn0iUC7d56XysaMMy8eWSOc0j3fGvoiGWkf
         P5B5kR2VeYOnK9uv8EMBgI95Acn+mwKJfusBIP0nsWzDzQ3b/C6lse4kVHeG7cf4oDcX
         WxW1mwE6JmETVc9GWwXGsaYnCN5g01DteXHrnS/AnUPwVBB8+MF7I1JtOSTrYoBMSCrF
         GMf92lEHdRrZwzhcnNRC6QkY2YRbNNXp6QCy0b4ovNv4ca55UfYKqpdhBmE6Trd7RmBt
         0z0UhYoPLAePp826F0I8mhRfkugPOB832329yNQ1C79vSE8g6uMUX1CqHQseraXg5XBF
         s96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780593967; x=1781198767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D2Ypl5piwY28pT58DbtYmX3qX3B63YsIgDUM1eIk9WU=;
        b=CKtxTjdbC5/IVsSBQZ8ueYeiqykTwe4anbHVN+Ln4i1sPisxoVgJDIHdEF33MQdtLI
         qLLzqWc81jqCECEnNXke8gXIji/Q/Nqt7Xpqbei+aIl8EKOIfqRfji1kf4nscJX4teVD
         2I11HZIvcqSe5gadPwm8BTD7pN8qBFIbfysco5tr3kMfxAcDSrafOLU0XbdQUjiEguB8
         WQIW6INqwAJgapdjXOMSJGgpokIYtSV3exd7nN5WPb4dWnTwg0o6hGlzHxw88lY7OMIq
         AiOm/ZlSPX6EKZmNnlzN5i+GSCwGj/qadAFQlZpkDxjjzR74j9MkiX/MuV7HHtpq7lZc
         dAVQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DdDAOhyL2A/tjGBxev1xcoCGHEkpekwqIZfFGyoEozWhHxNWPRDbbjl6zRTvUvPv0r2aRVG7Rkw==@kvack.org
X-Gm-Message-State: AOJu0YwxFv13y49MQhNUT04m3DeiCVT4nSwuxee5GlIjuEPZlWLfhm5W
	ZCBrRGiy9MLySz0gGZfBvYEy5mPCCTjCO5acom50oZ+2uym6Wh9C8gISorPjNDR8Xwl/ppmeokd
	n57MWIHx6kOsGWMk+DKdjl0QnW6PJqHOpVpdS1l56
X-Gm-Gg: Acq92OGgqHwcDQ1Xk1ufqlzkrhtzADgNaIF7inauLekYbC4Nj9elNWPplZURUW+IDBZ
	9bC3OCSZGIeKwJ5u5/rXIcR+C7J/+vSj6FUZCCcd+r65WGggN5+Db3F7cbNdAHB4xSJUsAtflg8
	VzCKCPeJ4AfnN+73kspheNh+B13uIcSntylfjn+FVkThW3sRFMbE72wDS/lMidKM0qV32xgoEQM
	kW9ICfz7G9qd6DSckkdZMl00DUXtwtHYwNJFZ6SxoWpCrM4Hj0/TOsO8j4PlmAyOeOjIqaEV+Aa
	/1cCwjA9gm8qbXA=
X-Received: by 2002:a2e:bc0f:0:b0:396:7fcc:6864 with SMTP id
 38308e7fff4ca-396af184c47mr26680891fa.11.1780593967025; Thu, 04 Jun 2026
 10:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu> <CALCETrULMixRGJyGqAAujW7RN6PP2f_Orn2Y_0hpPMjRqQnY7Q@mail.gmail.com>
 <aiGjUqI59e966oBu@1wt.eu>
In-Reply-To: <aiGjUqI59e966oBu@1wt.eu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Jun 2026 10:25:55 -0700
X-Gm-Features: AVVi8CcvIM4HOiXbU2YWmKHDS7Pmkfl5RMnbxKamS5RAB8P23IrY-5hOK2SZPKo
Message-ID: <CALCETrX=DzbbG_ns2Y1A83F_Vpd8NQqZfKr4nUkteGgOLrkngA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F70F1C001B
X-Rspam-User: 
X-Stat-Signature: nsmgfhh18s1smznborhzqsrzhwtcynoy
X-Rspamd-Server: rspam09
X-HE-Tag: 1780593968-398741
X-HE-Meta: U2FsdGVkX19k2dYiNiQgvRfTGS1ri83TR6mQ5FrDBHNCqwD1hFDrzK37MT8ij0M/RiiCgmR1AkkRFAzq2JUpQN4wwh3DfQLYk7xZ8aGljfLNyMdp2HzA23EJHqUQ8YW1wMxeLMth7dlAso+fICwj1pL0vksjuBS9w2HqonQ09r9006ez0sbitVSn3kGbgLiVY5zAdFZyBcSGD5I5PqwQ1pj6jnuxLgPDhyWdwzbz9JTBzwIi81rYN4sO8JZPcQDw0zYFvO420OSVLa6usyOKI9ztbyQSMYsUEfdp3Q8plR0aXwohX7qtBqkpSX36ugafPAu1i2iSnR/38iWNN3H8CpWx4OUXCIkQpQzXTELFeEHqmQbTCGGJAxt29hcROt11CG7hkAhTxjnyvhEuH4hAdqBmR3Rrb9I/FT/E+gM/z0j+OJ9wFd+lIugGQcric8Mz/nx9C+LuchryWHIc7Uy3Bk4kyhx2dibc+F5ge933QefmL71BphQxJYZIDlpkoq7ngoEwM9zEWErf99LXpfqF9FL94y022ngsOB6iQM0fg3IXTNj/0/Mx0XUIgpQgOA/X6KerTqpkWcKGy/rUqc8V+Qhio5NLa153Zf/hLZypMPLF5ZmHrjk7O5KVtdL7pbQJk+xFy5wG3Yj5Yus4tewa915nGqX/yVP8oo3XcxSu5OT0YLNKNB8d9RM6QBaStBuM3nxA3CSAYey898uq4/L1WJ+Ip3NbFINCR4SzTb/GQXKp7qD4IDF/W8l0iNyvxw7rGLgm0VatArQJZ1HdAdaIzGYviV929oQ8REXCuGBYel/mvGQ1B5DJKp2vHC/fhJ9q4j14hTTHWLTPYz4ALWs0LMDG4WN4nYXoO0U8WFMOBbwUCuxYiKcsaV5V8iqxXIiE3C2MJIw0gpHf4LAsq2GA7BynjS/K1AixUwuaSO/ZiPqmvBDUSqwATQcm4NpapHJ/tkiDnHCn6Zwe1pCiBuJ
 MEL3jjnG
 1aeNC4439lbWKHCjNduT+6aDYwAJM9blrg39W3C5HnhH38zxZYNLJQirVh5/cuWzUDZX/Jn6o+uGdMf2lKcOJXoX9uc3M3ZNzzOkkCd4mPG1xXQ9KhjgI0hNu7UbTGqhzjuUtGjVwO3uuJsiQZlCy91XBygjmkMibGgZsjXLz3u05nJlt/GXgqxpsqxkOLF/y70M9sAM7izV7ZBnh73SFFgAoRUGjiyY1i2ftsndNUHD3SIv+sxrigz7u0JM2QpQRbtq4XpBH1kdRKEaxr/NrR4IWraoKKcPr6/FZFE4LHErKmZCPAARZ8WGBhhcxKJ1kJMgtOlxNMd4Cs7k+qRcWEWwlSnodGf1KGINUM9KY2n/1DINWv9S6znZkZgypn/3YBqV2DR22PWKPpGb+LgpXoX2ZgYlDUNv6YdPylo1UQgbvxsBblELFhRLeDtj570R5Ky+1JTl0YNwRJiyhhVsOdF4V1U+ko/3Hwz0KHVmc0hpH0Sk7XkbwBRhGbLV55dkoKlbTkJNW70c+1HIN1oWdJsqXPO0AbPtZEfoIV3QHyf/bWksDoPv/sIyPI7uv/KDG9musA5A+kF0pgdvXrFzoxKMH7SjUlsi0yD7CGsnXprb1pCAXtnIiiP5jiILqT9diPNGf1iJ3JFCvr6eR5u6FIDXOzCtFOYiM928YPgvoCyiwAFIUYuvJUHRXcWbOCsKeS2xKUrBxEEO6xzS2n3w/0AiGu2xi9mA3D5rYSAefx/Z3UJbSMD0m4EDgWJLdmKQkY6zAFwO5lWe5rS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 9:09=E2=80=AFAM Willy Tarreau <w@1wt.eu> wrote:
>
> On Thu, Jun 04, 2026 at 08:53:15AM -0700, Andy Lutomirski wrote:
> > On Wed, Jun 3, 2026 at 11:32 PM Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> > > > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.o=
rg> wrote:
> > > >
> > > > > On Mon, 1 Jun 2026 18:33:25 +0100
> > > > > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > > >
> > > > > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > > > >
> > > > > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* =
would be
> > > > > > > a big simplification.
> > > > > >
> > > > > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > > > > Communications between the kernel and fuse server at least used=
 to
> > > > > > seriously want that, so that would be one place to look for unh=
appy
> > > > > > userland...
> > > > > >
> > > > > > splice-related logics in fs/fuse/dev.c is interesting; another =
place
> > > > > > like this is kernel/trace/, but I'm less familiar with that one=
.
> > > > > >
> > > > > > rostedt Cc'd (miklos already had been)
> > > > >
> > > > > Thanks for the Cc. The tracing ring buffer was specifically made =
to be used
> > > > > by splice and the libtracefs has a lot of code to use it as well.=
 As
> > > > > reading the ring buffer literally swaps out the write portion wit=
h a blank
> > > > > read portion, that portion (sub-buffer) is used to be directly fe=
d into
> > > > > splice, providing a zero-copy of the trace data from the write of=
 the event
> > > > > to going into a file.
> > > > >
> > > > > trace-cmd defaults to using splice to copy the tracing ring buffe=
r directly
> > > > > into files to avoid as much copying during live recordings as pos=
sible.
> > > > >
> > > > > Whatever changes we make, I would like to make sure there's no re=
gressions
> > > > > in performance of trace-cmd record.
> > > >
> > > > Well yes, The patchset seems sensible from a quality POV.  But to m=
ake
> > > > a decision we should first have a decent understanding of its downs=
ide
> > > > impact.
> > > >
> > > > I haven't seen a description of that impact in the discussion thus =
far.
> > > > And that description is owed, please.
> > > >
> > > > I assume a small number of specialized applications are using
> > > > vmsplice() to great effect?  What are those applications?  What is =
the
> > > > impact of this change?
> > >
> > > > Once we are armed with that information, is there some middle groun=
d in
> > > > which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> > > > tricky cases and still permit vmsplicing if the application is
> > > > appropriately restrictive in it usage?
> > >
> > > I'm using vmsplice() + tee() + splice() in high-performance applicati=
ons,
> > > load generators to be precise, and soon a cache. This is super conven=
ient
> > > and extremely efficient:
> > >
> > >   - vmsplice() is used to prepare a "master" pipe with data to be sen=
t
> > >     over TCP or kTLS
> > >   - then for each request, we do tee() from this master pipe to per-r=
equest
> > >     pipes.
> > >   - the per-request pipes are those that are used to deliver the data=
 to
> > >     the socket via splice().
> > >
> > > So we effectively use vmsplice(), tee() and splice() here, and for ex=
actly
> > > the reasons they were designed: only play with page refcount and not =
copy
> > > data. The code is here for the curious:
> > >
> > >    https://git.haproxy.org/?p=3Dhaproxy.git;a=3Dblob;f=3Dsrc/haterm.c
> > >
> > > and its ancestor is here:
> > >
> > >    https://github.com/wtarreau/httpterm/blob/master/httpterm.c
> > >
> > > It simply doubles the network bandwidth compared to not using that.
> > > (62 Gbps per core vs 31). I would seriously miss it if I couldn't use
> > > this anymore.
> > >
> >
> > Wait a moment.  This is neat, but it's literally just a benchmark,
> > right?
>
> No, it's a benchmark *tool*: it's being used to stress production code,
> which is important and super hard at high loads. You place it after your
> proxy and you measure the performance of the proxy (which is supposed not
> to be as capable as the testing tools otherwise the methodology revolves
> to testing the testing tools, which is not the point).
>
> > I skimmed the code, and it doesn't look like a production
> > workload, either.  And you manage to get around the awfulness of the
> > vmsplice API's complete failure to tell you when it's done with a
> > buffer by ... never actually changing the contents of the buffer.  Do
> > you have any idea how you would write correct code that uses vmsplice
> > for sends and then *ever* mutates the data without literally
> > munmapping (or madvise or something) the data do you can safely mutate
> > it?
>
> I'm not sure what you mean here Andy. I *do not* need to change the
> data, it's just a pre-made pattern.

What I mean is: this particular pattern seems limited for use in an
actual webserver as a opposed to a load-tester.

> > Or discover that we already have something better, perhaps :)
> >
> > https://man7.org/linux/man-pages/man3/io_uring_prep_send_zc.3.html
>
> io_uring is different. We tried it "the dirty way" in the past, by
> emulating a poller, and it's not worth it this way. And in order to
> do it the right way, it needs to be done totally differently, which
> has impacts all over the stack. The code in the file pointed to above
> is just for the httpterm testing feature, but the rest is much more
> complex.

I'm curious how this kludge does:

https://github.com/amluto/zc_bench

I vibe-coded this up without much care, and I don't have the hardware
needed to actually run it in an interesting manner.  But, on a Linux
VM on an Apple M4, I can push about 130Gbps on a single core over
loopback.  In theory this will do zerocopy sends (but not over
loopback), and I would hope that it runs *faster* than vmsplice + tee.

(I have a fancy workstation that can do a whopping 2.5Gbps.  I could
probably jury-rig a test over Thunderbolt at higher speeds.  I have
systems that are not available for this test right now that can do
10Gbps.  But someone probably needs 40Gbps or better hardware for a
genuinely interesting test.)

--=20
Andy Lutomirski
AMA Capital Management, LLC

