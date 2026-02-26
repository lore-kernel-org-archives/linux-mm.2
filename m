Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60915FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BECE46B0089; Wed, 25 Feb 2026 19:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B709C6B008A; Wed, 25 Feb 2026 19:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51D06B008C; Wed, 25 Feb 2026 19:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91F796B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:59:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34EEF1603DA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:59:48 +0000 (UTC)
X-FDA: 84484800456.06.BC01B62
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BA48140006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:59:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4h0ePY7s;
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHz2OqGdbyMrS9ge5RZAFhEE1Lxhci21FT69bhpnuog=;
	b=Ks14n3B1YvjMkoAJxK2Z1NHX3kxEH2VAVBpxPbr2hQRFvWGlAd8OwltNwSFRzKQJsTrbFb
	OgSTnr0hUb9pITSIHxnMO//9TzzDBITgtHabJg4RzLPhhhoA01PPgfGEFZz4BFfFQi+XUY
	mm4k4xeKnWi/YNCneo5yFQwru7i+rFw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4h0ePY7s;
	spf=pass (imf09.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772067586; a=rsa-sha256;
	cv=pass;
	b=zo8IUkPZU3dbCLXQ0xAbGy/dsroFa0c6EP/rm7UDhsf3hcPIy8iCR7TItRtc8HQOPubVV7
	Xc+uA8EF9Q5wtDsebBnmMfufMGvRywbIU6x9L9Xv68epG406KV2CjcY7w46veoMJmSHAf7
	KC5pJimDDgODrcmp33xkdjqvyzLTp70=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a964077671so41025ad.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:59:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772067585; cv=none;
        d=google.com; s=arc-20240605;
        b=f/BbvJfqHrD7s4PdrOlmDzRKxGTQqYdyLt7clcibCnUON+oPDj1GmmxI8DjlAp/2M9
         rAHba/Jit+E5O7NrjkRuBt64RslUR9ga1tA2CvKnZDqOkjfo5rrN8CLqbBf6N6oJKMLK
         mFbmOsreAWBqNmyWPIzKTeJR/QZe/tE3qfdLPjEdpJfn3m17JL0J0XyxabQQk9C9jASB
         eFrBXFUYVGyc0GrxFwk/HnBCGqEhmX7+w8ZzUXPBet8tWzf6VK4ObzdfwjbGy9OM+U3m
         /y51zopWvWcaMUNWQ8axo/SJNI/8w093E8UQb16f3ZS8XWGPDKR/X+cpDINglCcSa/+D
         T2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FHz2OqGdbyMrS9ge5RZAFhEE1Lxhci21FT69bhpnuog=;
        fh=h1ghntCUahcWJLszdhPlUyTrmPZm3aym/zYrCnuikcE=;
        b=UYR1g2ec+oKvNbmQqCjf2PpyD9zk+rC9GB2qVPuB1EE7EzVVhdT6OZnhfQwtTUMCuB
         ldfVNILSjUbf+ASGRaVRWWRN/N3QYjoWWVfdl2kOKicW1ll0A1HOMMy+awtmEav+Yy4K
         XBVIcA/8e9IALKugqCmNLe0aVW7b+D7gLNb0vsl6EIaH6imaT4e0ks5Mp/9CoCVAeGlC
         sKIdOcQVwxW71sI9vbnzDZyKaE/OK9I3Ji4fVB+LpDgkbujH5QDy9dWP6oF395kSJe1a
         HmHVfGLZ+ibrfL0U8h1Qb8Lt1l+fe1oKjGiIZcKfZZqdXvuiQxKfvmer2NlFplHIv6Xm
         4FZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772067585; x=1772672385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHz2OqGdbyMrS9ge5RZAFhEE1Lxhci21FT69bhpnuog=;
        b=4h0ePY7sdtPvhXiUkXxfEFR3iytn9X68SDL8bwY+c7JhYI6P83F/PjHft6J/jwGFB9
         jonyAVE/F55a65I5XvVW5jTPx52fwNCtqV8Kh0/UXtNJnmkUXJgR/MnytLgvlKCJX4y7
         fN1cDu34nAenN0K6/EzSQw4MBrlGN/pmkVrxiwF7w9PFbRHf7qLGxVv1b37/3c3WlDyv
         iLeXMD152W2EDNJX1NoyWY7fh8t9wBbmRKvwxUt5Ly5nJqhthbkEg14mMrHblMDBm5N8
         LXRynNiwZySDOpRJb90oueuu0Us9RjGSie08YKQbRwN8WgjU6E1SHxvf9KGR5/S59o79
         0rFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772067585; x=1772672385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FHz2OqGdbyMrS9ge5RZAFhEE1Lxhci21FT69bhpnuog=;
        b=MY8/R1HmVkzGMY77jSqs7dbVbTO3gaMavgcPcPcFSyB+MVJNYxd9xD9CCDbVnMsEG0
         SrwFM1u5TrjKXudhx682xyXll2J/fta4xVWKg15XODALUBIPlPfDhVOI8CQ0EiDeXfQH
         XKG1QjZR6RBOau3sva/9aTefxdpRvzMJoeuwa4MvkJP1wrQSFqUOngNXBMDUlkif79P5
         kP+0XReCDF9M3v2fiHn0c2eqnRgV/S5DZGBHXsZ7gVOUppKuHWiSFA5prqB8JXxQal6v
         RWbCdod3HrfZFQC6AYHM0NFGnPsoxWW2iTFCZcrUg4pojSwrGopAvHATKOBoMAJyZBSv
         FB5g==
X-Forwarded-Encrypted: i=1; AJvYcCVJRMo0GPOeH6kXY/oG4cO3J+W+mEubE/j4CudzJZMi4ay8dJGuih/dY57hD21XpBanL1nvpALp1g==@kvack.org
X-Gm-Message-State: AOJu0Yz9B6fU2NfYd8OriV5er/BCiRYRtKQwrO+IDknwQKALI2FrdYha
	11RF9D4g3w0qVNh6vhyhjEf06DifLfXOm2ZODkmjEKRX8wD/PGakN0Z4Q2uPm7Z/nC+ItzC7IKP
	NN/lJgIVqcBuicLJx2LPdA0bYg6GxpP814ivwVsCexSIY/u/jdQokfeVKuJ1ahA==
X-Gm-Gg: ATEYQzy7krCVxSaOXzcujo5YG1QvHKasZOZg04RYyfwKpUfoXoFacN5FtauZrK2GkYT
	mViRa6uh/FRayU8x5Kk8Rev/Th2Z5Q/43qPNNr36M3ogzERrSGnHdDfnXYtMjyYlJtU/YayD2hR
	SJr5ghBGW35SUS4asct8xUbldMSuPi+rZZycIPb6kgeMjiNMDRCYCi35VgtvLxoaSRmY5NFwlkT
	6L4nmvtU1vXZO2Kj/ItptK+PqBI7SfPZJxNJPboMjse1gEzLZhkW6BaxYEkFN6w9kUpgoDyqIIW
	zIMfdfP+FQv62gx0XuOjpIuZCxZgaOsvMbw+gQ==
X-Received: by 2002:a17:902:d591:b0:2a7:6c4e:5924 with SMTP id
 d9443c01a7336-2adf771234emr1097485ad.12.1772067584366; Wed, 25 Feb 2026
 16:59:44 -0800 (PST)
MIME-Version: 1.0
References: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
In-Reply-To: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 16:59:32 -0800
X-Gm-Features: AaiRm52zkyKS25vK4zF7KslOaW8BVmD3GHKeqPaU1KeVua9G1kz9-Ir8LEJm_1o
Message-ID: <CAC_TJvdzgOdvf9=uDaF=zBFWdZ5J9Qh=04Y9OHry6V+YiA-3EQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] mshare - sharing page tables across processes
To: anthony.yznaga@oracle.com
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	Isaac Manjarres <isaacmanjarres@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	android-mm <android-mm@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BA48140006
X-Stat-Signature: 1pkfxnui7us8r8o4zzmuf95astcan6qq
X-Rspam-User: 
X-HE-Tag: 1772067586-321022
X-HE-Meta: U2FsdGVkX19et12NhuE7BqENkuS/iZy/UHuLCk7Vl7tSWz3pMPi2S3q16pG8+iK/0Mam2PfpCq1EOp0WuRT2gMmzLECavqvxPBVBonh67wywUTNAl4MdmLVCZCyjeRhcVX+DEah8yyDDQuc9Lw8leoX74vYvxiB1K5emId76afyd+bb/5epcEZh0NCzDmd3+qDd+E+t32GurGLiPtMWACLEU8eVyv9Tk7rF0QwMFPChrGoObtUYjMBahz/9AmRx76dtmW+9FNu9hAuqEpd7bTQn2UWRqmNuzpYTp4RQ89kZ9r82iSJDLGoeRrdjwnrJcT3WdN6IgyUiCHTKxMcZdOtoHcO5xy8S743wNaJlSJGER4aawpqQcTgkpvsvCC1MiyMMWcagXO2SqycjrGjAJ22lHkwG0LxWzy/I0RCd30InGVAWuxvA8X8svmBNB7a4WzrwjUbVlwM8BTrdDFHBgLePdjrc4obFjT5RTNuU3iwB1evYNX07qbQNoUFQBGZl1wYZNCrYFbWIs8fLcIYB/UK8gR49wtLs5wHes3ChhHnIFvCjH+oAIIS9k79ZUQHli8TAEICbW+t6NX0WX2KXxtmaKQW5VNuiHMA+SZm7zp5UzjrLLCyFgOggZ87ZX8idL5GHRqohNqB593AxLEQdBh3oVfwzIf59uWpXqOEJ1aoJi7kMpE6Yge8AfpncpZNFp3spMlBqZvBkuhzwnhMjOShKqPjUbHBtv4GgB1u+gVgtFepQ6kOjOPqWTuSciVYheKCQlGqwA+ThabiqDM2YuRSoF20DY2YfAer46eZiWV2Kw128o7cHE/plMTZJcnrov9Qs0MwbcrmiSlZztX8umTbdsFycOiWjGjHs+hEZQE/Hx48xWfMjK6TIhDRGexorYCeknUnEwuxA3rw5DUCkudL3bbFRnfH7j3lIekIrD93OYjccfKF/QLuPTs4EfK6uuPl+cWd1x5p12LMzx7UQ
 aEAAuhQz
 XNGfbw8PEvgHy9gU7mptdmqbzWGhoOz08D/L36HhaIg/5aMiB8WoprEMHWB94a/th27rh0hu77i/waSeqjwS+VbEb/utJppJHdTYH3O000yE23NesLJeVIK9aKK9i9y8r1bqZv2IG00odDwXAzAYTvftLRg4ZBGbp1rcHUTx2TSDpDl1x+20PYvzjfkQ5k4cw/huoD1WrUEiQ5zhajTnKNgAaIalMwX8FaTAxXa4ugsGEiCeEruqgl8nCUWXJetRfpRxSGiJVB6IkLzt2ricbTLsFJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 6:12=E2=80=AFPM <anthony.yznaga@oracle.com> wrote:
>
> mshare is a new form of shared memory that shares resources between
> processes, namely the page tables entries and VMAs of the shared
> objects. Advantages include reduced memory consumption through
> eliminating the need for duplicated PTEs in each process, reduced
> overhead needed to fault shared pages into multiple processes, and the
> ability for updates to the memory such as protection changes to be
> immdediately visible to all sharing processes.
>
> For some time now the proposed API has continued to evolve. With
> feedback from mm maintainers, a new approach using syscalls is being
> taken to create, attach, and deattach mshare regions and to map and
> manipulate the memory objects within a region.
>
> Let's discuss the current state of the API and technical challenges of
> managing and accomodating shared page tables in the kernel.
>
> Anthony
>
>
> References:
>
> https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@o=
racle.com/
> https://lore.kernel.org/linux-mm/20250404021902.48863-1-anthony.yznaga@or=
acle.com/

Hi Anthony,

I would be very interested in participating in this discussion at LSF/MM.

As mentioned on the mailing list, we are currently exploring similar
optimizations to deduplicate page tables for Android's Zygote process.
I'd love to join the session to discuss how the proposed sharing
mechanisms might align.

Thanks,
Kalesh

>
>

