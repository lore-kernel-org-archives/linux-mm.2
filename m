Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748EC606EEB6
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQ/nNwuo
Received: by kanga.kvack.org (Postfix)
	id 7EF356B05BC; Tue,  3 Nov 2026 11:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5406B05BD; Tue,  3 Nov 2026 11:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC5B6B05BE; Tue,  3 Nov 2026 11:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4411A6B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:39:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C442214047E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:42 +0000 (UTC)
X-FDA: 85394369004.07.DBF5D24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27FB88000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XQ/nNwuo";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRMdP7FIxigSeDqcsgSUYB9b6BNpnFg/wAimEqAPxEs=;
	b=mCv85pn1znCDCrk3qItV+3VonpcWGzlRlt4XnHxe8ipRKy1dybLwekw3DJ5S58ys9gs83P
	N0Ilp6D0w6OnSR7OUH5dwxC5/b+LHrAsTyotz0RL1Wbk7VQq8Etvkinpv6uOq13JXyebel
	NHBwoYmc49rhYEtIHb3XV4wBmB1YhJ8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XQ/nNwuo";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723981;
	b=gdv4QwF0rkoX0n5wENsBYP/CPpa4YXgohIqoeAW+d3bYedm4DsgOhM82Dj7V38FKfrI2hb
	hjw9foARUYgHoWrGqm6iA3SEBS0lbDv+vsFNIaLy25+gKjBC0cPHdZiJCr0tK3KL0FsYAD
	mUiseTuQ0IODKVXjUgfESmSBYIPND8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 671AE43B17;
	Tue,  3 Nov 2026 16:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEE01F00919;
	Tue,  3 Nov 2026 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723980;
	bh=MRMdP7FIxigSeDqcsgSUYB9b6BNpnFg/wAimEqAPxEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQ/nNwuodkCBEaeYlDPGXQ2NBVyaOu+nuL3oimLdbSA+hZnOnCMyBEv8BHrYgwk/m
	 6VRgMfJqoFXxFR5EnYPGf1ATg09kypE1i/OaABYNEuqdO5agM7Fzz0cf/3n/BjKYZM
	 khi+2N49jwOr20dXQgySeVZQ9Nuqnaii9228cGUqmaA9nvn0Bo2QFeSR7x+Zj7TPBN
	 DsnqdVZFYyPlE6EQk0LhOkfKZhj3KG2NrjGmOrcKa6pa4XM1UVKP+71e961E7SnLHB
	 vkz6atcfZ7p6OvtLIdPK+tn8iO+IrzrFsPPZ5RZWhEpbynuwXHq2NjfH4sIU6OUzUj
	 zfP/LOwKBMdTQ==
Date: Tue, 3 Nov 2026 17:39:28 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 28/38] scsi: esas2r: bound the lengths of the HBA,
 SMP and firmware ioctls
Message-ID: <20261103-aufmischen-achthundert-reitschule-d97de42062c2@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-28-59422ed3e465@kernel.org>
 <sashiko-outbox-195500@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195500@kernel.org>
X-Stat-Signature: dgnschcptt4q7jarjqtgxcyeai77r18t
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 27FB88000A
X-HE-Tag: 1793723980-720308
X-HE-Meta: U2FsdGVkX1/boJGiEVTLC3z/3bbtb+TuH99gCOE3171kyXB0gqQqZLqYoan0W7mcE9c9chjuk0nJMzWTJOkFshgiRH+TSvPVQRn96ZP3M7J4tat8c2fu8XIhTCHiSWhCO1PKbhwmo8Ae+keho4kNu4g83o5+r0AYQJ+CxPRg4qjWc6Brxov7ORniuZCkPtCPB7+0LMJCR4/KVxRa5oWOBZ+qAnuWZdp+t09LApGImwg0NEmIxDkdJY43L2u30VgJ/RZeGuriTFDLMHq3Clv+Aybsa0x8zBNPr3WoR9GT0Srwk02ae2kU1EXQcSTmDZMptDKUYLkHtXSQAsxJLLBdXrsWsWY4y06r9Y5wezN4KGDjsm/hC5Mjefz7mgaw/NB0jSZyT58dKebNESOGAmeDoQajykjTBenuI0getaovEYMds9au0f1zw/C0oWMnwVtNzAmXMEArDUv0lCJixM3Vly+P6VLfFoN4xchecdt5xb1FSbEOKmXvA7fR+Mn082YsLnTcKtbqHlAc+2A8lDs0rb7paKEDfOKRx9SHQ3xEXdTPWpZFQTFKDzLc8+KxuVJigKio1ox4gMbx6501sUweeof7D/53K3AoiQbHTVOj2YC5N2n07nMyaSSpoFWPKRBHvdtcYtMfuAeOa15cSXaB8oeBNfokPee1ltZKYQMklQb+glnqW7J+G5amPzHWjeaPGHfCyzbcGhehbWj08tTAKhCP2YS0L/EDp5uzKvGe3OKhtUyLH7NOzCjbDauYUNCr73ADsFlzKvyUDaRs3JfrFevuD2alxGEt4i6HWSWR8DwTaNkqXNjPNjvTQYNufKSw/O+AK9OxD8SL/f/YkEfbHn23pi0YFYhcMs8l01ButSoc6bYg7QRA+VzBSQYLqCF9cTEx0Di3z3HXqnfGzMJh1ElLum4pyp/B8Zrf+IAvbSUZU5E6z/BGOIi60fXCBdp/8C9GKlGDx0wcsNHNNor
 ucr/cYFN
 fzP4F+xw78pxChAj8ASCzG7b5bGREiYyOsIex76+ZAlWrcfqSsdG3/MyRmH1kJlkphEptiV+i7wAVTSwCqBm75vWwSvLuArnLbMxBsdvNAMx975Y1rzvcYpol9Ehf6OlwzoeyAJPLgZ0L/dVjQgrJZs+DSeRA/q1e7E3oXjStFT6SnSO3OKnIb9hYsLwUZ9sgvdrzbuQL8oSz46ko9S0zwFkXHx++xDVkv6O6yOUoa0ayOrMElql322RWGSnmkAQISVrS5QjFwrCBHsxeCrjOxnvDMXA7yjctZ2sglKzHXCmB60HHgYdS9PhfGk2/h1sWWiAW9hNFAFmcfSLgaO/RuAdON8LKs6QVdihNGhK1xzNn72+ddGN2grUhtxaIZsJeoMhUjmir/Ixs8vNRJA4U4SyUQ3yXd7x9zovgMK/ZfMDD2kz8SYbDlHBu3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:22PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: esas2r: TOCTOU race on data_length in handle_hba_ioctl() via read_hw()
> --
> 
> commit 8af21917bc01e9991b2ab872e7a4c38c91a6e388
> Author: Christian Brauner <brauner@kernel.org>
> 
> scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls
> 
> This commit adds bounds checks on user-supplied lengths for the HBA, SMP,
> and firmware ioctls in esas2r to prevent out-of-bounds reads and writes past
> the end of struct atto_express_ioctl and a->local_atto_ioctl.
> 
> > diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
> > index 3f7c1d131ec34..f99318f61c934 100644
> > --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> > +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> 
> [ ... ]
> 
> > @@ -1221,11 +1231,16 @@ static void hba_ioctl_done_callback(struct esas2r_adapter *a,
> >  	}
> >  }
> >  
> > +/* @room is the size of the buffer that starts with @ioctl_hba. */
> >  u8 handle_hba_ioctl(struct esas2r_adapter *a,
> > -		    struct atto_ioctl *ioctl_hba)
> > +		    struct atto_ioctl *ioctl_hba, size_t room)
> >  {
> >  	struct esas2r_buffered_ioctl bi;
> >  
> > +	/* The data follows @ioctl_hba in the same buffer. */
> > +	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
> > +		return IOCTL_INVALID_PARAM;
> > +
> >  	memset(&bi, 0, sizeof(bi));
> >  
> >  	bi.a = a;
> 
> [Severity: High]
> Can a concurrent write_hw() bypass this bounds check when handle_hba_ioctl()
> is called from read_hw()?

This whole codepath as currently implemented is structurally fscked.
So it's not something fixable in this series apart from the glaringly
obvious.

But for the record:

- The ATTONode entry thing is created as a side effect of reading
  another file.

  So esas2r_info() registers a character device and creates
  /proc/scsi/esas2r/ATTONode the first time it runs. That pins a global
  pointer to whichever host triggered it. So the control node only
  exists after someone looked at the host info. So it is bound to the
  first host and not to the adapter it operates on.


  The lifeteime is then tied to the module and not to the host.
  The entry is removed in esas2r_exit() on module exit.

  But the directory it lives in belongs to SCSI. That removes it when
  the last host of the template goes away.

  So unbind or hotunplug of the last adapter removes a non-empty
  directory... the dir is unlinked and the ATTONode leaks and stays
  reachable through a cached dentry.

  And the global host pointer dangles.

  So every ioctl on the node dereferences it.

  It's like non-empty directory removal basically. Fun.


- No privilege check anywhere. The node is created with mode 0 so 0444
  with procfs the the driver never calls capable().

  Hence, any local user can read and write firmware and NVRAM and issue
  VDA commands.

- The ioctl protocol itself (where to begin):
  - Plain-number commands
  - one struct copied in whole
  - unbounded lengths taken straight from userspace (well, that's fixed here)

Sorry, I'm not going to redesign esas2r.
And from what I can tell that ATTO stuff is legacy anyway so good
riddance as far as I'm concerned.

